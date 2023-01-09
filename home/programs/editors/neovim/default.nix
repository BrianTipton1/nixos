{ config, pkgs, lib, inputs, ... }: {
  programs.neovim = {
    enable = true;
    extraLuaPackages = with pkgs.lua53Packages; [ fennel ];
    extraPackages = with pkgs; [
      sumneko-lua-language-server
      nodePackages_latest.vscode-json-languageserver
      unstable.nil
      stylua
      jq
      nixfmt
      lazygit
      fnlfmt
      inputs.fennel-ls.packages.${pkgs.system}.default
    ];
    plugins = with pkgs.vimPlugins; [
      telescope-nvim
      nvim-tree-lua
      catppuccin-nvim
      everforest
      alpha-nvim
      nvim-web-devicons
      which-key-nvim
      pkgs.unstable.vimPlugins.nvim-lspconfig
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
      mini-nvim
      fennel-vim
      hotpot-nvim
    ];
    extraConfig = let
      files = lib.filesystem.listFilesRecursive ./config;
      luaRequire = module: builtins.readFile (builtins.toString "${module}");
      luaConfig = builtins.concatStringsSep ''

        ---------------
      '' (map luaRequire files);
    in ''
      set clipboard+=unnamedplus
      set guifont=JetBrainsMono\ Nerd\ Font\ Mono
      colorscheme everforest
      :lua << EOF
      ${luaConfig}
      EOF
    '';
  };
}
