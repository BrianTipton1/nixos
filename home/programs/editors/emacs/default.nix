{ config, pkgs, ... }: {
  programs.emacs.enable = true;
  programs.emacs.extraPackages = (epkgs: [ epkgs.dap-mode epkgs.vterm ]);
  home.sessionVariables.EDITOR = "emacs";
  # Start Emacs fullscreen - Applied KDE setting to move to third monitor
  xdg.configFile = {
    "autostart/Emacs".text = ''
      [Desktop Entry]
      Name=Emacs
      GenericName=Text Editor
      Comment=Edit text
      MimeType=text/english;text/plain;text/x-makefile;text/x-c++hdr;text/x-c++src;text/x-chdr;text/x-csrc;text/x-java;text/x-moc;text/x-pascal;text/x-tcl;text/x-tex;application/x-shellscript;text/x-c;text/x-c++;
      Exec=emacs -fs %F
      Icon=emacs
      Type=Application
      Terminal=false
      Categories=Development;TextEditor;
      StartupWMClass=Emacs
    '';
  };
}
