{ config, pkgs, ... }: {
  imports = [
    ./shell/zsh.nix
    ./programs/git/git.nix
    ./programs/wezterm/wezterm.nix
    ./programs/neovim/neovim.nix
  ];
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "brian";
  home.homeDirectory = "/home/brian";

  # Packages that should be installed to the user profile.
  home.packages = [
    #Browsers
    pkgs.firefox
    pkgs.qutebrowser
    pkgs.ungoogled-chromium

    # School
    pkgs.anki-bin
    pkgs.obsidian

    # Email
    pkgs.thunderbird
    pkgs.birdtray

    # Assorted
    pkgs.bitwarden
    pkgs.bitwarden-cli
    pkgs.qbittorrent
    pkgs.mullvad-vpn
    pkgs.xclip
    pkgs.rofi
    pkgs.keyutils
    pkgs.unstable.d2

    # Office Tooling 
    pkgs.libreoffice
    pkgs.libsForQt5.skanlite
    pkgs.poppler_utils

    # Voice/Video Call      
    pkgs.zoom-us

    # IDE's
    pkgs.jetbrains.pycharm-professional
    pkgs.jetbrains.idea-ultimate
    pkgs.jetbrains.rider
    pkgs.jetbrains.clion
    pkgs.unstable.vscode.fhs

    # Latex
    pkgs.kile
    pkgs.texlive.combined.scheme-full

    # Audio
    pkgs.rnnoise-plugin

    # Screen Capture
    pkgs.obs-studio

    # Photo/Video Edit
    pkgs.libsForQt5.kdenlive
    pkgs.gimp
    pkgs.vlc

    # Emulators
    pkgs.mgba
    pkgs.snes9x
    pkgs.dolphin-emu
    pkgs.mupen64plus

    # Non-Steam Games
    pkgs.xivlauncher
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
