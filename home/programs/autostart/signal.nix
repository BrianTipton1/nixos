{
  xdg.configFile = {
    "autostart/signal-desktop.desktop".text = ''
      [Desktop Entry]
      Categories=Network;InstantMessaging;Chat
      Comment=Private messaging from your desktop
      Exec=signal-desktop --enable-features=UseOzonePlatform --ozone-platform=wayland --use-tray-icon --start-in-tray %U
      Icon=signal-desktop
      Name=Signal
      Terminal=false
      Type=Application
      Version=1.4
    '';
  };
}
