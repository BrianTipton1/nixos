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

  mesa.enable = true;
  mesa.git.enable = true;

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  # End Graphics Driver

  # Kernel Config
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.initrd.kernelModules = [ "amdgpu" ];

  # Video and Sound PCIE ID's for 2070 Super. PCIE ID for Intel M.2
  boot.kernelParams = [ "amdgpu.sg_display=0" ];
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

  # Gtk theming in wayland/ Virt-Manager
  programs.dconf.enable = true;
  #

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  audio.enable = true;
  audio.noise-torch-input =
    "alsa_input.usb-Blue_Microphones_Yeti_Nano_8838B13699040506-00.analog-stereo";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  programs.zsh.enable = true;
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
      "podman"
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
    glxinfo
    vulkan-tools
    wayland-utils
    clinfo
    libimobiledevice
    ifuse

    # Terminal Emulators
    kitty
  ];

  plasma.enable = true;

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

  officejet-6978.enable = true;

  # Fonts
  fonts.fonts = with pkgs; [
    jetbrains-mono
    nerdfonts
    pkgs.stable.openmoji-color
    league-of-moveable-type
    comic-relief
  ];
  fonts.fontDir.enable = true;
  # End Fonts

  flatpak.enable = true;

  # File Systems
  fileSystems."/home/brian/drive_two" = {
    device = "/dev/disk/by-uuid/98f3c60b-2788-4116-9cca-bed48c2bc0bd";
    fsType = "ext4";
    options = [ "nofail" ];
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

  # Gaming
  gaming.enable = true;
  services.hardware.openrgb.enable = true;

  services.usbmuxd = {
    enable = true;
    package = pkgs.usbmuxd2;
  };

  # Vfio
  vfio.enable = true;
  vfio.pam-fix.enable = true;
  vfio.usb-ids = [ "046d" "17ef" "0416" "045e" ];
  vfio.cpu-type = "amd";
  vfio.users = [ "brian" ];
  vfio.pcie-ids =
    [ "10de:1e84" "10de:10f8" "10de:1ad8" "10de:1ad9" "8086:f1a8" ];
}
