{
  xdg.desktopEntries = {
    "com.ulduzsoft.Birdtray" = {
      name = "Birdtray";
      exec = "env -u WAYLAND_DISPLAY birdtray";
      icon = "com.ulduzsoft.Birdtray";
    };
  };
  # xdg.configFile = {
  #   "autostart/com.ulduzsoft.Birdtray.desktop".text = ''
  #     [Desktop Entry]
  #     Categories=Network;Email;
  #     Exec=env -u WAYLAND_DISPLAY birdtray
  #     Icon=com.ulduzsoft.Birdtray
  #     Keywords=Email;E-mail;Newsgroup;Feed;RSS
  #     Name=Birdtray
  #     StartupNotify=true
  #     Terminal=false
  #     Type=Application
  #     X-MultipleArgs=false
  #   '';
  # };
}
