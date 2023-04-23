inputs:
{ config, lib, pkgs, ... }:

with lib; {
  options.plasma.enable = lib.mkEnableOption "plasma";
  config = mkIf config.plasma.enable {
    services.xserver.displayManager.sddm.enable = true;
    services.xserver.desktopManager.plasma5.enable = true;
    programs.kdeconnect.enable = true;
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-kde ];
    environment.systemPackages = with pkgs; [
      libsForQt5.ark
      libsForQt5.ksystemlog
    ];

  environment.sessionVariables.KWIN_DRM_NO_AMS = "1";
  environment.sessionVariables.KWIN_FORCE_SW_CURSOR = "1";
  };
}
