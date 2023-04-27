inputs:
{ pkgs, lib, config, ... }:
with lib; {
  options.vfio = {
    enable = mkEnableOption "vfio";
    pam-fix.enable = mkEnableOption "vfio pam-fix";
    script.enable = mkEnableOption "vfio script";
    users = mkOption {
      default = [ ];
      description = ''
        user(s) allowed to use vfio
      '';
    };
    pcie-ids = mkOption {
      default = [ ];
      description = ''
        pcie ids of device(s) to be passed through
        see show-iommu.sh to get ids.

        Example output from script: 
        IOMMU Group 24:
        09:00.0 VGA compatible controller [0300]: NVIDIA Corporation TU104 [GeForce RTX 2070 SUPER] [10de:1e84] (rev a1)
        09:00.1 Audio device [0403]: NVIDIA Corporation TU104 HD Audio Controller [10de:10f8] (rev a1)
        09:00.2 USB controller [0c03]: NVIDIA Corporation TU104 USB 3.1 Host Controller [10de:1ad8] (rev a1)
        09:00.3 Serial bus controller [0c80]: NVIDIA Corporation TU104 USB Type-C UCSI Controller [10de:1ad9] (rev a1)

        To pass this device to get VGA and Audio we would need all 4 pcie-ids like below:
          vfio.pcie-ids = [ "10de:1e84" "10de:10f8" "10de:1ad8" "10de:1ad9" ];
      '';
    };
    cpu-type = mkOption {
      default = "";
      description = ''
        CPU Vendor (AMD | Intel)
      '';
    };
    usb-ids = mkOption {
      default = [ ];
      description = ''
        usb ids of device(s) allowed to be hot swapped
        this is not needed for spice hot swap
        Example: 
        $ lsusb --> Bus 005 Device 003: ID 0416:3fcd Winbond Electronics Corp. VD104M
        "0416" would be a value to pass to this option 
      '';
    };
  };
  config = let
    iommu-script = pkgs.writeShellScriptBin "show-iommu.sh"
      (builtins.readFile ./show-iommu.sh);
  in mkMerge [
    (mkIf config.vfio.enable {
      assertions = [
        {
          assertion = config.vfio.cpu-type == "amd" || config.vfio.cpu-type
            == "intel";
          message =
            "Supply a correct cpu type to vfio module. ( 'amd' | 'intel' )";
        }
        {
          assertion = builtins.length config.vfio.users > 0;
          message = "Supply a user(s) to vfio module";
        }
        {
          assertion = builtins.length config.vfio.pcie-ids > 0;
          message =
            "Must supply pcie ids to be passed through to vfio kernel param";
        }
      ];

      boot.initrd.kernelModules = let
        required-mod =
          if config.boot.kernelPackages.kernel.version >= "6.2.0" then [
            "vfio_pci"
            "vfio"
            "vfio_iommu_type1"
          ] else [
            "vfio_pci"
            "vfio"
            "vfio_iommu_type1"
            "vfio_virqfd"
          ];
      in required-mod;

      boot.kernelParams = let
        iommu_type = if config.vfio.cpu-type == "amd" then
          "amd_iommu=on"
        else
          "intel_iommu=on";
        param = "vfio-pci.ids=" + concatStringsSep "," config.vfio.pcie-ids;
      in [ param iommu_type ];

      services.udev.extraRules =
        if builtins.length config.vfio.usb-ids == 0 then
          concatStrings (map (x: ''
            SUBSYSTEM=="vfio", OWNER="${x}", GROUP="kvm"
          '') config.vfio.users)
        else
          concatStrings ((map (x: ''
            SUBSYSTEM=="vfio", OWNER="${x}", GROUP="kvm"
          '') config.vfio.users) ++ map (x: ''
            SUBSYSTEM=="usb", ATTRS{idVendor}=="${x}", MODE="0666"
            SUBSYSTEM=="usb_device", ATTRS{idVendor}=="${x}", MODE="0666"
          '') config.vfio.usb-ids);

      security.pam.loginLimits = if config.vfio.pam-fix.enable then
        let
          user-limits = map (x: {
            domain = "${x}";
            item = "memlock";
            type = "hard";
            value = "unlimited";
          }) config.vfio.users ++ map (x: {
            domain = "${x}";
            item = "memlock";
            type = "soft";
            value = "unlimited";
          }) config.vfio.users;
        in user-limits
      else
        [ ];
    })
    (mkIf config.vfio.script.enable {
      environment.systemPackages = [ iommu-script ];
    })
  ];
}
