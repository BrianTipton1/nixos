_:
{ pkgs, inputs, ... }: {

  home.packages = with pkgs; [
    # Fonts
    jetbrains-mono
    nerdfonts

    # School
    anki-bin
    obsidian

    # Assorted
    neofetch
    qbittorrent
    d2
    jq
    fzf
    exa
    vscode
    inputs.cssxpd.packages.${pkgs.system}.default
    inputs.hm_purge.packages.${pkgs.system}.default

    # IDE's / Development
    lazygit
    gh

    # Photo/Video Edit
    gimp

    # Interpreters
    lua5_4

    #Nix Specific
    nixfmt
    nil
  ];

  home.stateVersion = "22.11";

  programs.home-manager.enable = true;

  # Editors
  editors.vscode.enable = true;
  editors.neovim.enable = true;

  # Terminal
  terminal.kitty.enable = true;

  #Interpreters
  interpreters.ipython.enable = true;

  #Shell
  shell.zsh.enable = true;

  fonts.fontconfig.enable = true;

  # Nix
  nix.unfree.enable = true;
  nixpkgs.config.useGlobalPkgs = true;
  nixpkgs.config.useUserPackages = true;
}
