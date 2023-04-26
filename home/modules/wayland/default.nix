_:
{ config, lib, pkgs, ... }: {
  options.wayland.enable = lib.mkEnableOption "wayland";
  config = lib.mkIf config.wayland.enable {
    home.sessionVariables.NIXOS_OZONE_WL = "1";
    home.sessionVariables.MOZ_ENABLE_WAYLAND = "1";
  };
}
