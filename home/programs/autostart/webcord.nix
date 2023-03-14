{
  xdg.configFile = {
    "autostart/WebCord.desktop".text = ''
      [Desktop Entry]
      Categories=Network;InstantMessaging
      Comment=A Discord and Fosscord electron-based client implemented without Discord API
      Exec=webcord --start-minimized --ozone-platform=wayland
      Icon=webcord
      Name=WebCord
      Type=Application
      Version=1.4
    '';
  };
}
