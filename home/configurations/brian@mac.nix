_:
{ pkgs, inputs, ... }: {
  imports = [ ../shell ];

  home.packages = with pkgs; [
    #Browsers
    firefox

    # School
    anki-bin
    obsidian

    # Assorted
    neofetch
    bitwarden
    bitwarden-cli
    qbittorrent
    mullvad-vpn
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
    signal-desktop

    # IDE's / Development
    jetbrains.pycharm-professional
    jetbrains.clion
    # jetbrains.clion
    lazygit
    gh

    # Latex
    kile
    texlive.combined.scheme-full


    # Photo/Video Edit
    gimp
    vlc

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
  ];


  programs.home-manager.enable = true;


  nixpkgs.config.allowUnfreePredicate = (pkg: true);
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.useGlobalPkgs = true;
  nixpkgs.config.useUserPackages = true;
}
