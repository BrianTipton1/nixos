_:
{ config, lib, pkgs, inputs, ... }: {
  options.virtualization.tools.enable =
    lib.mkEnableOption "virtualization tools";
  options.virtualization.uefi.enable = lib.mkEnableOption "virtualization uefi";
  config = lib.mkMerge [
    (lib.mkIf config.virtualization.tools.enable {
      home.packages = with pkgs; [
        distrobox
        # pods
        inputs.podman-compose-devel.packages.${pkgs.system}.default
        virt-manager
      ];
    })
    (lib.mkIf config.virtualization.uefi.enable {
      # Need for UEFI - Currently broken
      home.file.".config/libvirt/qemu.conf".text = ''
        nvram = ["/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd"]
      '';
    })
  ];
}
