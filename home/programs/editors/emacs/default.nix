{
  programs.emacs.enable = true;
  programs.emacs.extraPackages = (epkgs: [ epkgs.dap-mode epkgs.vterm ]);
}
