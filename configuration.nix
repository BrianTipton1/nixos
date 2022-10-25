# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  ## Nvidia Setup 
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  # Required for nvidia with wayland to load drm mod 
  boot.kernelParams = [ "nvidia-drm.modeset=1" ];
  ### End Nvidia Setup
  
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

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
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.brian = {
    isNormalUser = true;
    description = "brian";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      firefox
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
      # Editors
      vim 
      pkgs.neovim
      pkgs.sublime4
      
      # Utilities
      wget
      pkgs.util-linux
      pkgs.pciutils
      pkgs.bat
      pkgs.exa
      pkgs.fzf
      pkgs.git
      pkgs.killall
      pkgs.clamav
      pkgs.unzip
      pkgs.sublime-merge
      pkgs.wl-clipboard
      pkgs.ripgrep      
      pkgs.htop
      
      # Voice/Video Call      
      pkgs.discord
      pkgs.zoom-us

      # IDE's
      pkgs.jetbrains.pycharm-professional

      # Office Tooling 
      pkgs.libreoffice

      #Fonts
      pkgs.jetbrains-mono
      pkgs.nerdfonts

      # Compilers/Interpreters
      pkgs.gcc
      pkgs.lua
      pkgs.python38
      pkgs.nodePackages.npm

      # Terminal Emulators
      pkgs.kitty

      # Assorted
      pkgs.bitwarden
      pkgs.qbittorrent
      pkgs.mullvad-vpn
      
      # Audio
      pkgs.rnnoise-plugin
      
      # Gnome Extensions/Themes
      pkgs.graphite-gtk-theme
      pkgs.tela-circle-icon-theme
      gnomeExtensions.appindicator      
  ];

  # Need this with appindicator https://nixos.wiki/wiki/GNOME
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

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


  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
  
  ## Default Shell to zsh
  users.defaultUserShell = pkgs.zsh;
  ## End zsh

  ## Virtual Box Stuff
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "brian" ];
  #virtualisation.virtualbox.guest.enable = true;
  #virtualisation.virtualbox.guest.x11 = true;
  ## End Virtual Box

  ## Docker Setup
  virtualisation.docker.enable = true;
}
