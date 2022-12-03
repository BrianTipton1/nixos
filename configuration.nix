{ config, pkgs, ... }: {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

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

  ## Nvidia Setup 
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  # Required for nvidia with wayland to load drm mod 
  boot.kernelParams = [ "nvidia-drm.modeset=1" ];
  hardware.nvidia.powerManagement.enable = true;
  ### End Nvidia Setup

  # Xmonad
  services.xserver.windowManager.xmonad.enable = true;

  # KDE Plasma Setup
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

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
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      #Browsers
      pkgs.firefox

      # School
      pkgs.anki-bin
      # Email
      pkgs.thunderbird
      pkgs.birdtray

      # Assorted
      pkgs.bitwarden
      pkgs.qbittorrent
      pkgs.mullvad-vpn
      pkgs.xclip

      # Office Tooling 
      pkgs.libreoffice

      # Voice/Video Call      
      pkgs.zoom-us

      # IDE's
      pkgs.jetbrains.pycharm-professional
      pkgs.jetbrains.idea-ultimate
      pkgs.jetbrains.rider
      pkgs.libsForQt5.kate
      pkgs.unstable.vscode

      # Audio
      pkgs.rnnoise-plugin

      # Screen Capture
      pkgs.obs-studio

      # Photo/Video Edit
      pkgs.libsForQt5.kdenlive
      pkgs.gimp

      # Emulators
      (retroarch.override {
        cores = [
          libretro.dolphin
          libretro.snes9x
          libretro.mupen64plus
          libretro.mgba
        ];
      })
      libretro.dolphin
      libretro.snes9x
      libretro.mupen64plus
      libretro.mgba
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [
    # Editors
    pkgs.neovim
    pkgs.sublime4

    # Utilities
    pkgs.wget
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
    pkgs.file
    pkgs.github-desktop
    pkgs.cachix
    pkgs.direnv

    # Compilers/Interpreters
    pkgs.lua
    pkgs.nodejs

    # Global Language Servers/ Formatters
    pkgs.unstable.nil
    pkgs.nixfmt

    # Terminal Emulators
    pkgs.kitty
    pkgs.wezterm
  ];

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

  ## Default Shell to zsh
  #users.defaultUserShell = pkgs.zsh;
  # Aliases and Plugins
  programs.zsh = {

    enable = true;
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;

    ## Aliases
    shellAliases = {
      vim = "nvim";
      vi = "nvim";
      ll = "exa --long --git --icons --no-filesize";
      ls = "exa --long --git --icons --no-filesize";
      l = "exa --long --all --git --icons --no-filesize";
      lr = "exa --long --all --git --tree --icons --no-filesize";
      ld = "exa --long --all --git --tree --icons --no-filesize --git-ignore";
      rg = "rg -i";
      cat = "bat";
      nuke = "rm -rf";
      update = "sudo nixos-rebuild switch";
      upgrade = "sudo nixos-rebuild switch --upgrade";
      sysadmin =
        "sudo cp $HOME/Developer/nixos/configuration.nix /etc/nixos/configuration.nix && sudo cp $HOME/Developer/nixos/flake.nix /etc/nixos/flake.nix && sudo nixos-rebuild switch";
      sysedit = "cd $HOME/Developer/nixos/ && code .";
      updatedb = "sudo updatedb";
      copy = "xclip -selection c";
      ipython =
        "nix-shell $HOME/Developer/NixShells/IPython/shell.nix --command ipython";
      mkJup = ''
        docker run -v "''${PWD}":/home/jovyan/work -p 8888:8888 jupyter/datascience-notebook'';
      nix-editor = ''nix-shell --command "code $PWD; return"'';
      repl =
        "nix-shell $HOME/Developer/NixShells/ghci/shell.nix --command ghci";
    };

    ohMyZsh = {
      enable = true;
      plugins = [ "git" "sudo" "fzf" "z" ];
      theme = "half-life";
    };
    enableGlobalCompInit = false;

    promptInit = ''
      mkMonad() {
          if [ -z "$1" ]
          then 
            echo "No argument supplied for mkMonad"
          else 
            mkdir "$1" && cd "$1" && nix-shell -p "haskellPackages.ghcWithPackages (pkgs: with pkgs; [ cabal-install ])" --run "cabal init" && cp $HOME/Developer/NixShells/HaskellBase/default.nix .
          fi
      }
    '';

    loginShellInit = ''
      export ZSHZ_DATA="$HOME/.cache/zsh/.z"
      # Create a cache folder for zcompdump if it isn't exists
      if [ ! -d "$HOME/.cache/zsh" ]; then
          mkdir -p $HOME/.cache/zsh
      fi
      export ZSH_COMPDUMP="$HOME/.cache/zsh/zcompdump-$HOST-$ZSH_VERSION"
    '';
  };
  ## End zsh

  ## Virtual Box Stuff
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "brian" ];
  #virtualisation.virtualbox.guest.enable = true;
  #virtualisation.virtualbox.guest.x11 = true;
  ## End Virtual Box

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
  ## End Steam

  # Fonts
  fonts.fonts = with pkgs; [ jetbrains-mono nerdfonts ];
}
