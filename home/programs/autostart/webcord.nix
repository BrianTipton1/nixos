{
  xdg.configFile = {
    "autostart/WebCord.desktop".text = ''
      [Desktop Entry]
      Categories=Network;Email;
      Exec=flatpak run --branch=stable --arch=x86_64 --command=run.sh io.github.spacingbat3.webcord --start-minimized
      Icon=io.github.spacingbat3.webcord
      Name=WebCord
      Terminal=false
      Type=Application
      X-MultipleArgs=false
    '';
  };
}
