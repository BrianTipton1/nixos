inputs:
{ pkgs, lib, config, ... }:
with lib; {
  options.virt.vms.enable = mkEnableOption "virt vms";
  options.virt.containers.podman.enable =
    mkEnableOption "virt containers podman";
  options.virt.containers.docker.enable =
    mkEnableOption "virt containers docker";
  options.virt.containers.enable = mkEnableOption "virt containers";
  config = mkMerge [
    (mkIf config.virt.vms.enable {
      networking.bridges.br0.interfaces = [ "enp5s0" ];
      networking.interfaces.enp5s0.useDHCP = true;
      networking.interfaces.br0.useDHCP = true;

      virtualisation.virtualbox.host.enable = true;
      users.extraGroups.vboxusers.members = [ "brian" ];
      virtualisation.virtualbox.host.enableExtensionPack = true;
      virtualisation.virtualbox.guest.enable = true;
      virtualisation.virtualbox.guest.x11 = true;

      virtualisation.libvirtd = {
        enable = true;
        qemu.ovmf.enable = true;
        qemu.runAsRoot = false;
        allowedBridges = [ "br0" ];
      };
    })
    (mkIf config.virt.containers.podman.enable {
      virtualisation.podman.enable = true;
    })
    (mkIf config.virt.containers.docker.enable {
      virtualisation.docker.enable = true;
    })
    (mkIf config.virt.containers.enable {
      virtualisation.docker.enable = true;
      virtualisation.podman.enable = true;
    })
  ];
}
