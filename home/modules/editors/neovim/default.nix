_:
{ config, lib, pkgs, ... }: {
  options.editors.neovim.enable = lib.mkEnableOption "editors neovim";

  config = lib.mkIf config.editors.neovim.enable {
    programs.neovim = {
      enable = false;
      extraPackages = with pkgs; [
        sumneko-lua-language-server
        nodePackages_latest.vscode-json-languageserver
        nil
        stylua
        jq
        nixfmt
        lazygit
        shfmt
      ];
      plugins = with pkgs.vimPlugins; [
        telescope-nvim
        nvim-tree-lua
        catppuccin-nvim
        everforest
        alpha-nvim
        nvim-web-devicons
        which-key-nvim
        pkgs.vimPlugins.nvim-lspconfig
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
        (nvim-treesitter.withPlugins (p: with p; [ tree-sitter-lua ]))
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
  };
}
