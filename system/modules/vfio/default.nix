inputs:
{ pkgs, lib, config, ... }:
with lib; {
  options.vfio = {
    enable = mkEnableOption "vfio";
    pam-fix.enable = mkEnableOption "vfio pam-fix";
    users = mkOption {
      default = [ ];
      description = ''
        user(s) allowed to use vfio
      '';
    };
    pcie-ids = mkOption {
      default = [ ];
      description = ''
        pcie ids of device to be passed through
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
        usb ids of devices allowed to be hot swapped
        Example: 
        $ lsusb --> Bus 005 Device 003: ID 0416:3fcd Winbond Electronics Corp. VD104M
        "0416" would be a value to pass to this option 
      '';
    };
  };
  config = mkMerge [
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
          message = "Supply a user to vfio module";
        }
        {
          assertion = builtins.length config.vfio.pcie-ids > 0;
          message = "Supply pcie ids to be passed through to vfio module";
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
  ];

}
