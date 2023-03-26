_:
{ config, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Allow for mounting NTFS drive
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "nyx";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  ## Graphics Drivers Setup 
  services.xserver.videoDrivers = [ "amdgpu" ];
  mesa-git.enable = false;

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  # End Graphics Driver

  # Kernel Config
  boot.kernelPackages = pkgs.linuxPackages_zen;

  boot.initrd.kernelModules = [
    "amdgpu"

    "vfio_pci"
    "vfio"
    "vfio_iommu_type1"
    ## This module I believe isn't needed in kernels >= 6.2.X
    # "vfio_virqfd"
  ];

  # Video and Sound PCIE ID's for 2070 Super. PCIE ID for Intel M.2
  boot.kernelParams = [
    "amd_iommu=on"
    "intel_iommu=on"
    "vfio-pci.ids=10de:1e84,10de:10f8,10de:1ad8,10de:1ad9,8086:f1a8"
  ];
  boot.blacklistedKernelModules = [ "nvidia" "nouveau" ];

  ## Obs-Studio Virtual Camera
  boot.extraModulePackages = with config.boot.kernelPackages;
    [ v4l2loopback.out ];

  # Activate kernel modules (choose from built-ins and extra ones)
  boot.kernelModules = [ "v4l2loopback" "snd-aloop" ];

  # Set initial kernel module settings
  boot.extraModprobeConfig = ''
    options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
  '';
  ## End Obs setup
  # End Kernel Config

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.KWIN_DRM_NO_AMS = "1";
  environment.sessionVariables.KWIN_FORCE_SW_CURSOR = "1";

  # Gtk theming in wayland/ Virt-Manager
  programs.dconf.enable = true;
  #

  # KDE Plasma Setup
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  programs.kdeconnect.enable = true;
  # End Kde

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Sound Config
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  programs.noisetorch.enable = true;
  # End Sound Config

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.brian = {
    isNormalUser = true;
    description = "brian";
    shell = pkgs.zsh;
    extraGroups = [
      "input"
      "libvirtd"
      "networkmanager"
      "wheel"
      "docker"
      "scanner"
      "lp"
      "kvm"
      "audio"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Editors
    neovim

    # Utilities
    zip
    wget
    util-linux
    pciutils
    usbutils
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
    glxinfo
    vulkan-tools
    wayland-utils
    clinfo

    # Terminal Emulators
    kitty
  ];

  # System services
  ## Flatpak
  services.flatpak.enable = true;
  xdg.portal.extraPortals =
    [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-kde ];

  ## Mullvad
  services.mullvad-vpn.enable = true;

  ## mlocate
  services.locate = {
    enable = true;
    localuser = null;
    locate = pkgs.mlocate;
    interval = "hourly";
  };

  ## Clamav/Freshclam Service
  services.clamav.daemon.enable = true;
  services.clamav.updater.enable = true;
  # End System Services

  system.stateVersion = "22.11";

  # Vfio Related Rules/Settings
  ## Needed for permission to hotplug mouse and keyboard
  services.udev.extraRules = ''
    SUBSYSTEM=="vfio", OWNER="brian", GROUP="kvm"

    SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", MODE="0666"
    SUBSYSTEM=="usb_device", ATTRS{idVendor}=="046d", MODE="0666"

    SUBSYSTEM=="usb", ATTRS{idVendor}=="17ef", MODE="0666"
    SUBSYSTEM=="usb_device", ATTRS{idVendor}=="17ef", MODE="0666"

    SUBSYSTEM=="usb", ATTRS{idVendor}=="0416", MODE="0666"
    SUBSYSTEM=="usb_device", ATTRS{idVendor}=="0416", MODE="0666"
  '';

  ## Needed because memory page limit errors when using vfio
  security.pam.loginLimits = [
    {
      domain = "brian";
      item = "memlock";
      type = "hard";
      value = "unlimited";
    }
    {

      domain = "brian";
      item = "memlock";
      type = "soft";
      value = "unlimited";
    }
  ];
  # End Vfio rules

  # Virtulization
  ## Docker/Podman Setup
  virtualisation.docker.enable = true;
  virtualisation.podman.enable = true;
  virtualisation.podman.defaultNetwork.settings.dns_enabled = true;

  ## Virt-Manager/libvirtd
  virtualisation.libvirtd = {
    enable = true;
    qemu.ovmf.enable = true;
    qemu.runAsRoot = false;

    ### Needed for UEFI booting systems currently. Tmp fix 
    qemu.verbatimConfig = ''
      nvram = ["/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd"]
    '';
  };
  ## Simple spice hotplug of usb devices
  virtualisation.spiceUSBRedirection.enable = true;
  # End Virtualization

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Trust Users for cachix use
  nix.settings.trusted-users = [ "root" "brian" ];

  # Steam/Game Related Settings.. Better Bluetooth drivers for Gamepad
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
  ## Glorious Egg Roll Setup
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
  # End Steam

  # Printing/Scanning Options
  hardware.sane.extraBackends = [ pkgs.hplipWithPlugin ];
  hardware.sane.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  services.printing.drivers = [ pkgs.hplip ];
  services.printing.enable = true;
  # End Print/Scan

  # Fonts
  fonts.fonts = with pkgs; [
    jetbrains-mono
    nerdfonts
    pkgs.stable.openmoji-color
    league-of-moveable-type
  ];
  # End Fonts

  # File Systems
  system.fsPackages = [ pkgs.bindfs ];
  fileSystems = let # = let
    ## Internal 2TB SSD
    "/home/brian/drive_two" = {
      device = "/dev/disk/by-uuid/98f3c60b-2788-4116-9cca-bed48c2bc0bd";
      fsType = "ext4";
      options = [ "nofail" ];
    };
    ## Setup for fonts, icons for flatpak to find
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
    ## Create an FHS mount to support flatpak host icons/fonts
    "/usr/share/icons" = mkRoSymBind (config.system.path + "/share/icons");
    "/usr/share/fonts" = mkRoSymBind (aggregatedFonts + "/share/fonts");
  };
  # End File Systems

  # Nix Store
  ## Auto Garbage Collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  ## Compression
  nix.settings.auto-optimise-store = true;
  # End Nix Store

  # CoreCtrl
  programs.corectrl.enable = true;
  # End CoreCtrl

  # Nix ld, for use with nix-alien-ld
  programs.nix-ld.enable = true;
}
