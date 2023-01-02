{ config, pkgs, ... }: {
  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [ ];
    plugins = with pkgs.vimPlugins; [ ];
    extraConfig = ''
      imap jj <Esc>
    '';
  };
}
