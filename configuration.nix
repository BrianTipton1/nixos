{ config, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Allow for mounting NTFS drive
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "nixos"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  ## AMD Setup 
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  # For 32 bit applications
  hardware.opengl.driSupport32Bit = true;
  boot.initrd.kernelModules = [ "amdgpu" ];

  hardware.opengl.extraPackages = with pkgs; [ amdvlk ];
  # For 32 bit applications 
  # Only available on unstable
  hardware.opengl.extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
  ## End Amd

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.KWIN_DRM_NO_AMS = "1";

  # Gtk theming in wayland/ Virt-Manager
  programs.dconf.enable = true;
  #

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Obs-Studio Virtual Camera
  boot.extraModulePackages = with config.boot.kernelPackages;
    [ v4l2loopback.out ];

  # Activate kernel modules (choose from built-ins and extra ones)
  boot.kernelModules = [ "v4l2loopback" "snd-aloop" ];

  # Set initial kernel module settings
  boot.extraModprobeConfig = ''
    options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
  '';
  ## End Obs setup

  # KDE Plasma Setup
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  # End Kde

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.brian = {
    isNormalUser = true;
    description = "brian";
    shell = pkgs.zsh;
    extraGroups =
      [ "libvirtd" "networkmanager" "wheel" "docker" "scanner" "lp" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Editors
    neovim

    # Utilities
    wget
    util-linux
    pciutils
    bat
    exa
    fzf
    git
    clamav
    unzip
    sublime-merge
    wl-clipboard
    ripgrep
    htop
    file
    github-desktop
    cachix
    libsForQt5.ark
    flatpak-builder
    libsForQt5.ksystemlog
    virt-manager
    corectrl

    # Terminal Emulators
    kitty
    wezterm
  ];

  # List services that you want to enable:

  # Remote Desktop for lan
  #services.xrdp.enable = true;
  #services.xrdp.defaultWindowManager = "startplasma-x11";
  #networking.firewall.allowedTCPPorts = [ 3389 ];

  # Flatpak
  services.flatpak.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Mullvad
  services.mullvad-vpn.enable = true;

  # mlocate
  services.locate = {
    enable = true;
    localuser = null;
    locate = pkgs.mlocate;
    interval = "hourly";
  };

  # Clamav/Freshclam Service
  services.clamav.daemon.enable = true;
  services.clamav.updater.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

  # Virt-Manager/libvirtd
  virtualisation.libvirtd.enable = true;
  #

  ## Docker Setup
  virtualisation.docker.enable = true;

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Trust Users for cachix use
  nix.settings.trusted-users = [ "root" "brian" ];

  # Compression
  nix.settings.auto-optimise-store = true;

  # Steam/Game Related Settings.. Bluetooth
  programs.steam = {
    enable = true;
    remotePlay.openFirewall =
      true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall =
      true; # Open ports in the firewall for Source Dedicated Server
  };
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;
  nixpkgs.config.packageOverrides = pkgs: {
    steam =
      pkgs.steam.override { extraPkgs = pkgs: with pkgs; [ libgdiplus ]; };
  };
  hardware.xpadneo.enable = true;
  # Glorious Egg Roll Setup
  environment.sessionVariables = rec {
    XDG_CACHE_HOME = "\${HOME}/.cache";
    XDG_CONFIG_HOME = "\${HOME}/.config";
    XDG_BIN_HOME = "\${HOME}/.local/bin";
    XDG_DATA_HOME = "\${HOME}/.local/share";
    # Steam needs this to find Proton-GE
    STEAM_EXTRA_COMPAT_TOOLS_PATHS =
      "\${HOME}/.steam/root/compatibilitytools.d";
    # note: this doesn't replace PATH, it just adds this to it
    PATH = [ "\${XDG_BIN_HOME}" ];
  };
  programs.gamemode.enable = true;
  ## End Steam

  # Scanning
  hardware.sane.extraBackends = [ pkgs.hplipWithPlugin ];
  hardware.sane.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;

  # Fonts
  fonts.fonts = with pkgs; [ jetbrains-mono nerdfonts openmoji-color ];

  # Enable DRM Content with qutebrowser
  nixpkgs.overlays = [
    (final: prev: {
      qutebrowser = prev.qutebrowser.override { enableWideVine = true; };
    })
  ];
  # File Systems
  system.fsPackages = [ pkgs.bindfs ];
  fileSystems = let # = let
    # Internal 2TB SSD
    "/home/brian/drive_two" = {
      device = "/dev/disk/by-uuid/98f3c60b-2788-4116-9cca-bed48c2bc0bd";
      fsType = "ext4";
      options = [ "nofail" ];
    };
    # Setup for fonts, icons for flatpak to find
    mkRoSymBind = path: {
      device = path;
      fsType = "fuse.bindfs";
      options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
    };
    aggregatedFonts = pkgs.buildEnv {
      name = "system-fonts";
      paths = config.fonts.fonts;
      pathsToLink = [ "/share/fonts" ];
    };
  in {
    # Create an FHS mount to support flatpak host icons/fonts
    "/usr/share/icons" = mkRoSymBind (config.system.path + "/share/icons");
    "/usr/share/fonts" = mkRoSymBind (aggregatedFonts + "/share/fonts");
  };

  # Auto garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
