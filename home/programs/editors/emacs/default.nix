{ config, pkgs, ... }:

{
  programs.emacs.enable = true;
  home.sessionVariables.doom = "$HOME/.emacs.d/bin/doom";
  programs.emacs.extraPackages = (epkgs: [
    pkgs.haskell-language-server
    pkgs.nixfmt
    pkgs.unstable.nil
    epkgs.vterm
    pkgs.direnv
    epkgs.dap-mode
  ]);
  home.sessionVariables.EDITOR = "emacs";
}
