_:
{ pkgs, inputs, ... }: {

  home.packages = with pkgs; [
    #Browsers
    firefox
    ungoogled-chromium

    # School
    anki-bin
    remmina
    filezilla

    # Email
    thunderbird
    birdtray

    # Assorted
    yt-dlp
    neofetch
    soundux
    bitwarden
    bitwarden-cli
    qbittorrent
    mullvad-vpn
    clipboard-jh
    rofi
    keyutils
    d2
    jq
    inputs.cssxpd.packages.${pkgs.system}.default
    inputs.hm_purge.packages.${pkgs.system}.default

    # Office Tooling
    libreoffice-qt
    poppler_utils
    pdftk

    # Voice/Video Call
    zoom-us
    nheko

    # IDE's / Development
    jetbrains.pycharm-professional
    jetbrains.clion
    # jetbrains.clion
    lazygit
    gh

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

    #Nix Specific
    nixfmt
    nil
    inputs.nix-alien.packages.${system}.nix-alien
    comma
  ];

  # Editors
  editors.neovim.enable = true;
  editors.vscode.enable = true;
  editors.emacs.enable = true;
  editors.obsidian.enable = true;

  # Utilities
  git.enable = true;

  # Global Interpeters
  interpreters.ghci.enable = true;
  interpreters.ipython.enable = true;

  # Messaging
  messaging.signal.enable = true;
  messaging.signal.autostart.enable = true;

  # Shell
  shell.zsh.enable = true;

  # Terms
  terminal.wezterm.enable = true;
  terminal.kitty.enable = true;

  # Wayland Specific
  wayland.enable = true;

  # NixOS Specific
  nix.unfree.enable = true;
  nix.devenv.enable = true;
  nixpkgs.config.useGlobalPkgs = true;
  nixpkgs.config.useUserPackages = true;
  nixpkgs.config.permittedInsecurePackages = [ "electron-21.4.0" ];
  nix.stable-overlay.enable = true;

  # Virtualization
  virtualization.tools.enable = true;
  virtualization.uefi.enable = true;

  #Services
  services.clean-home.enable = true;

  # Script Bin
  scripts.enable = true;

  home.stateVersion = "22.11";

  programs.home-manager.enable = true;
}
