inputs:
{ config, lib, pkgs, ... }:
with lib; {
  options.nyx-vfio.enable = lib.mkEnableOption "nyx-vfio";
  config = (mkIf config.nyx-vfio.enable {
    vfio = ./generic.nix {
      inputs = inputs;
      pci-ids = "10de:1e84,10de:10f8,10de:1ad8,10de:1ad9,8086:f1a8";
      user = "brian";
    };
  });
}
