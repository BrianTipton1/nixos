{ config, pkgs, ... }: {
  imports = [
    ./shell/zsh.nix
    ./programs/git/git.nix
    ./programs/wezterm/wezterm.nix
    ./programs/editors/neovim/neovim.nix
    ./programs/editors/vscode/vscode.nix
    ./programs/editors/helix/helix.nix
    ./programs/pipewire/rnoise-plugin.nix
    ./programs/interpreters/ghci/ghci.nix
    ./autostart/programs.nix
    ./services/clean-home.nix
  ];

  home.username = "brian";
  home.homeDirectory = "/home/brian";

  home.packages = with pkgs; [
    #Browsers
    firefox
    qutebrowser
    ungoogled-chromium

    # School
    anki-bin
    obsidian

    # Email
    thunderbird
    birdtray

    # Assorted
    bitwarden
    bitwarden-cli
    qbittorrent
    mullvad-vpn
    xclip
    rofi
    keyutils
    unstable.d2
    jq

    # Office Tooling 
    libreoffice
    libsForQt5.skanlite
    poppler_utils

    # Voice/Video Call      
    zoom-us

    # IDE's
    jetbrains.pycharm-professional
    jetbrains.idea-ultimate
    jetbrains.rider
    jetbrains.clion

    # Latex
    kile
    texlive.combined.scheme-full

    # Audio
    rnnoise-plugin

    # Screen Capture
    obs-studio

    # Photo/Video Edit
    libsForQt5.kdenlive
    gimp
    vlc

    # Emulators
    mgba
    snes9x
    dolphin-emu
    mupen64plus

    # Non-Steam Games
    xivlauncher

    # Interpreters
    lua5_4
  ];

  home.stateVersion = "22.11";
  programs.home-manager.enable = true;
}
