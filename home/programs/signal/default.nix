{ config, lib, pkgs, ... }:

{

  xdg.configFile = {
    "autostart/Signal.desktop".text = ''
      Name=Signal
      Exec=signal-desktop --enable-features=UseOzonePlatform --ozone-platform=wayland  --start-in-tray --use-tray-icon --start-in-tray --use-tray-icon %U
      Terminal=false
      Type=Application
      Icon=signal-desktop
      StartupWMClass=Signal
      Comment=Private messaging from your desktop
      MimeType=x-scheme-handler/sgnl;x-scheme-handler/signalcaptcha;
      Categories=Network;InstantMessaging;Chat;    '';
  };
  xdg.desktopEntries = {
    "signal-desktop" = {
      name = "Signal";
      exec =
        "signal-desktop --enable-features=UseOzonePlatform --ozone-platform=wayland --use-tray-icon %U";
      categories = [ "Network" "InstantMessaging" "Chat" ];
      icon = "signal-desktop";
      comment = "Private messaging from your desktop";
    };
  };
}
