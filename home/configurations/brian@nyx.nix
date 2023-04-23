_:
{ pkgs, inputs, ... }: {
  imports = [ ../shell ../programs ../services ];

  # home.username = "brian";
  # home.homeDirectory = "/home/brian";

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
    signal-desktop
    webcord

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

    # Container/Virt tools
    distrobox
    pods
    inputs.podman-compose-devel.packages.${pkgs.system}.default
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

  nixpkgs.config.allowUnfreePredicate = (pkg: true);
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.useGlobalPkgs = true;
  nixpkgs.config.useUserPackages = true;
  nixpkgs.config.permittedInsecurePackages = [ "electron-21.4.0" ];
}
