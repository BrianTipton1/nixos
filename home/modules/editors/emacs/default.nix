_:
{ config, lib, pkgs, ... }: {
  options.editors.emacs.enable = lib.mkEnableOption "editors emacs";
  config = lib.mkIf config.editors.emacs.enable {
    programs.emacs.enable = true;
    programs.emacs.extraPackages = (epkgs: [ epkgs.dap-mode epkgs.vterm ]);
    home.sessionVariables.doom = "1";
  };
}
