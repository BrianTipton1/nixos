inputs:
{ pkgs, self, lib, config, ... }:
with lib;
let

  # Short hand funcs
  all-string = with builtins; e: (all (i: isString i) e);
  all-attrs = with builtins; e: (all (i: isAttrs i) e);

  check-pcie-id = with builtins;
    attr:
    # Checking that toplevel keys are correct
    if (all (i: i == "id" || i == "description") (attrNames attr)
      && (isString attr.description) && (isString attr.id)) then
      true
    else
      false;

  check-usb-attrs = with builtins;
    attr:
    if ((all (i: i == "name" || i == "id") (attrNames attr))
      && (isString attr.id) && (isString attr.name)) then
      true
    else
      false;

  check-pcie-attrs = with builtins;
    attr:
    # Checking that toplevel keys are correct
    if (all (i: i == "name" || i == "ids") (attrNames attr))
    # Checking that toplevel values are correct type
    && (isString attr.name) && (isList attr.ids) && (all-attrs attr.ids)
    # Checking that attr id's supplied are of correct form
    && (all (i: check-pcie-id (i)) attr.ids) then
      true
    else
      false;

  # Converts all of a single devices attribute ids to a comma seperated string
  pcie-attr-to-string = with builtins;
    lst:
    concatStringsSep "," (map (i: i.id) (lst));

  # Converts all devices into a comma sperated string
  all-device-attrs-to-string = with builtins;
    iterable:
    concatStringsSep "," (map (i: pcie-attr-to-string i.ids) (iterable));

  to-list-of-usb = with builtins;
    e:
    if (all (i: isString i) e) then e else map (x: x.id) e;

in {
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
        pcie device ids of device(s) to be passed through
        see show-iommu.sh to get id
        Example output from script: 
        IOMMU Group 24:
        09:00.0 VGA compatible controller [0300]: NVIDIA Corporation TU104 [GeForce RTX 2070 SUPER] [10de:1e84] (rev a1)
        09:00.1 Audio device [0403]: NVIDIA Corporation TU104 HD Audio Controller [10de:10f8] (rev a1)
        09:00.2 USB controller [0c03]: NVIDIA Corporation TU104 USB 3.1 Host Controller [10de:1ad8] (rev a1)
        09:00.3 Serial bus controller [0c80]: NVIDIA Corporation TU104 USB Type-C UCSI Controller [10de:1ad9] (rev a
        To pass this device to get VGA, Audio and USB-C we would need all 4 pcie-ids like below:
        vfio.pcie-ids = [ "10de:1e84" "10de:10f8" "10de:1ad8" "10de:1ad9" ]
        If just wanting to supply strings of pcie-ids no further thinking is needed.
        But using attribute sets provide benifits with the vfio script + documentation
        No mixing of types allowed though either either attribute sets or strings

        List of attribute sets should be of the below form: 
        vfio.pcie-ids = [
          {
            name = "nvidia-rtx-2070-super";
            ids = [
              {
                id = "10de:1e84";
                description = "VGA compatible controller";
              }
              {
                id = "10de:10f8";
                description = "HD Audio Controller";
              }
              {
                id = "10de:1ad8";
                description = "Host Controller";
              }
              {
                id = "10de:1ad9";
                description = "USB Type-C UCSI Controller";
              }
            ];
          }
          {
            name = "intel-m1-drive";
            ids = [
            {
              id = "8086:f1a8";
              description = "Non-Volatile memory controller";
            }
            ];
          }
        ];
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
        Example:
        vfio.usb-ids = [ "046d" "0416" ]


        If just wanting to supply strings of usb-ids no further thinking is needed.
        But using attribute sets provide benifits with the vfio script + documentation
        No mixing of types allowed though either either attribute sets or strings
        Example with sets:
        vfio.usb-ids = [
            {
              name = "Logitech Mouse Receiver";
              id = "046d";
            }
            {
              name = "Varmillo Keyboard";
              id = "0416";
            }
          ];
      '';
    };
  };
  config = mkMerge [
    (mkIf config.vfio.enable {
      assertions = with builtins; [
        {
          assertion = config.vfio.cpu-type == "amd" || config.vfio.cpu-type
            == "intel";
          message =
            "Supply a correct cpu type to vfio module. ( 'amd' | 'intel' )";
        }
        {
          assertion = length config.vfio.users > 0;
          message = "Supply a user(s) to vfio module";
        }
        {
          assertion = length config.vfio.pcie-ids > 0;
          message =
            "Must supply pcie ids to be passed through to vfio kernel param";
        }
        {
          assertion =
            # Check if all the ids are strings
            if (all-string (config.vfio.pcie-ids)) then
              true
              # Check if all the ids are attributes
            else if (all-attrs (config.vfio.pcie-ids)) then
            # If they are -> check to make sure all the attributes are of correct form
              (all (i: check-pcie-attrs i) (config.vfio.pcie-ids))
            else
              false;
          message =
            "See description in vfio/default.nix of how to pass the pcie-ids";
        }
        {
          assertion = # Check if all the ids are strings
            if (all-string config.vfio.usb-ids) then
            # if so Just eval to true
              true

              # Check if all the ids are attributes
            else if (all-attrs config.vfio.usb-ids) then
            # If they are all attrs -> check to make sure all the attributes are of correct form
              all (i: check-usb-attrs i) (config.vfio.usb-ids)
            else
              false;
          message =
            "See description in vfio/default.nix of how to pass the usb-ids";
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
        param = if (all-string config.vfio.pcie-ids) then
          "vfio-pci.ids=" + concatStringsSep "," config.vfio.pcie-ids
        else
          "vfio-pci.ids=" + (all-device-attrs-to-string config.vfio.pcie-ids);
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
          '') (to-list-of-usb config.vfio.usb-ids));

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
    # TODO
    (mkIf config.vfio.script.enable {
      # environment.systemPackages = with builtins;
      # let
      #   vfio-py = pkgs.callPackage ./vfio-py.nix {
      #     vfio-script = self.packages.x86_64-linux.vfio.script;
      #     config = config;
      #     pkgs = pkgs;
      #   };
      # in [ vfio-py ];
    })
  ];
}
