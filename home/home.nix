{ config, pkgs, inputs, ... }: {
  imports = [ ./shell ./programs ./services ];

  home.username = "brian";
  home.homeDirectory = "/home/brian";

  home.packages = with pkgs; [
    #Browsers
    firefox
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
    d2
    jq

    # Office Tooling
    libreoffice-qt
    libsForQt5.skanlite
    poppler_utils
    pdftk

    # Voice/Video Call
    zoom-us
    nheko
    signal-desktop
    webcord

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

    # Interpreters
    lua5_4

    # Nix lsp/fmt
    nixfmt
    nil

    inputs.nix-alien.packages.${system}.nix-alien

    # Container/Virt tools
    distrobox
    pods
    podman-compose
    virt-manager
  ];

  # Session Vars
  home.sessionVariables.NIXOS_OZONE_WL = "1";
  home.sessionVariables.MOZ_ENABLE_WAYLAND = "1";
  home.sessionVariables.doom = "1";

  home.stateVersion = "22.11";

  programs.home-manager.enable = true;

  # Need for UEFI - Currently broken
  home.file."/home/brian/.config/libvirt/qemu.conf".text = ''
    nvram = ["/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd"]
  '';
}
