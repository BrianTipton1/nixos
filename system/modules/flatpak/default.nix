inputs:
{ config, lib, pkgs, ... }:

with lib; {
  options.flatpak.enable = lib.mkEnableOption "flatpak";
  config = mkIf config.flatpak.enable {
    services.flatpak.enable = true;
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    system.fsPackages = [ pkgs.bindfs ];
    environment.systemPackages = with pkgs; [ flatpak-builder ];
    # Setup for fonts, icons for flatpak to find
    fileSystems = let
      mkRoSymBind = path: {
        device = path;
        fsType = "fuse.bindfs";
        options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
      };
      aggregatedFonts = pkgs.buildEnv {
        name = "system-fonts";
        paths = config.fonts.fonts;
        pathsToLink = [ "/share/fonts" ];
      };
    in {
      ## Create an FHS mount to support flatpak host icons/fonts
      "/usr/share/icons" = mkRoSymBind (config.system.path + "/share/icons");
      "/usr/share/fonts" = mkRoSymBind (aggregatedFonts + "/share/fonts");
    };
  };
}
