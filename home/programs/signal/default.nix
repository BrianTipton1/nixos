{
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
