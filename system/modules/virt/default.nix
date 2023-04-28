inputs:
{ pkgs, lib, config, ... }:
with lib; {
  options.virt.vms.enable = mkEnableOption "virt vms";
  options.virt.containers.podman.enable = mkEnableOption "virt containers podman";
  options.virt.containers.docker.enable = mkEnableOption "virt containers docker";
  options.virt.containers.enable = mkEnableOption "virt containers";
  config = mkMerge [
    (mkIf config.virt.vms.enable {
      virtualisation.libvirtd = {
        enable = true;
        qemu.ovmf.enable = true;
        qemu.runAsRoot = false;
      };
    })
    (mkIf config.virt.containers.podman.enable { virtualisation.podman.enable = true; })
    (mkIf config.virt.containers.docker.enable { virtualisation.docker.enable = true; })
    (mkIf config.virt.containers.enable {
      virtualisation.docker.enable = true;
      virtualisation.podman.enable = true;
    })
  ];
}
