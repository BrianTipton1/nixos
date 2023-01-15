{ config, pkgs, ... }: {
  imports = [ ./shell ./programs ./services ];

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
    remmina
    filezilla

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
    mangohud

    # Office Tooling 
    libreoffice-qt
    libsForQt5.skanlite
    poppler_utils
    pdftk
    # Voice/Video Call
    zoom-us

    # IDE's / Development
    jetbrains.pycharm-professional
    jetbrains.idea-ultimate
    jetbrains.rider
    jetbrains.clion
    lazygit

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
    prismlauncher

    # Interpreters
    lua5_4

    # Utilities
    direnv
  ];

  home.sessionVariables.NIXOS_OZONE_WL = "1";
  home.sessionVariables.doom = "1";

  home.stateVersion = "22.11";
  programs.home-manager.enable = true;
}
