{ config, pkgs, lib, ... }: {
  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      sumneko-lua-language-server
      nodePackages_latest.vscode-json-languageserver
      unstable.nil
      stylua
      jq
      nixfmt
      lazygit
    ];
    plugins = with pkgs.vimPlugins; [
      telescope-nvim
      nvim-tree-lua
      catppuccin-nvim
      alpha-nvim
      nvim-web-devicons
      which-key-nvim
      nvim-lspconfig
      vim-nix
      null-ls-nvim
      nvim-cmp
      luasnip
      cmp_luasnip
      cmp-nvim-lsp
      comment-nvim
      nvim-autopairs
      lualine-nvim
      gitsigns-nvim
      toggleterm-nvim
      vim-tmux-navigator
    ];
    extraConfig = let
      files = lib.filesystem.listFilesRecursive ./config;
      luaRequire = module: builtins.readFile (builtins.toString "${module}");
      luaConfig = builtins.concatStringsSep ''

        ---------------
      '' (map luaRequire files);
    in ''
      set clipboard+=unnamedplus
      colorscheme catppuccin-frappe
      :lua << EOF
      ${luaConfig}
      EOF
    '';
  };
}
