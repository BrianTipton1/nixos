{
  # Setup for https://github.com/werman/noise-suppression-for-voice
  xdg.configFile = {
    "autostart/com.ulduzsoft.Birdtray.desktop".text = ''
      [Desktop Entry]
      Categories=Network;Email;
      Exec=birdtray
      Icon=com.ulduzsoft.Birdtray
      Keywords=Email;E-mail;Newsgroup;Feed;RSS
      Name=Birdtray
      StartupNotify=true
      Terminal=false
      Type=Application
      X-MultipleArgs=false
    '';
  };
}
