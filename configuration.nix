{ config, pkgs, ... }:
let
  unstable = import
    (builtins.fetchTarball "https://github.com/nixos/nixpkgs/tarball/master")
    # reuse the current configuration
    { config = config.nixpkgs.config; };
in 
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
  ### End Nvidia Setup
  
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  # Disable Some Default Gnome Apps
  environment.gnome.excludePackages = [ 
    pkgs.gnome.geary
    pkgs.gnome-console
  ];

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
      firefox
      firefox-wayland
      # School
      pkgs.anki-bin      

      # Email
      pkgs.thunderbird

      # Assorted
      pkgs.bitwarden
      pkgs.qbittorrent
      pkgs.mullvad-vpn
      pkgs.flameshot

      # Office Tooling 
      pkgs.libreoffice

      # Voice/Video Call      
      pkgs.zoom-us

      # Gnome Extensions/Themes
      pkgs.graphite-gtk-theme
      pkgs.tela-circle-icon-theme
      gnomeExtensions.appindicator
      pkgs.gnomeExtensions.dash-to-dock
      pkgs.gnomeExtensions.clipboard-history
      pkgs.gnome.gnome-tweaks
      pkgs.whitesur-gtk-theme
      pkgs.whitesur-icon-theme
      pkgs.capitaine-cursors
      pkgs.gnomeExtensions.dark-variant     
      pkgs.gnomeExtensions.sur-clock   
      pkgs.gnomeExtensions.color-picker
      
      # IDE's
      pkgs.jetbrains.pycharm-professional
      pkgs.jetbrains.idea-ultimate
      pkgs.jetbrains.rider
      
      # Audio
      pkgs.rnnoise-plugin

    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
      # Editors
      pkgs.neovim
      pkgs.sublime4
      pkgs.vscode
      
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
      pkgs.file
      pkgs.github-desktop
      pkgs.cachix
      pkgs.direnv

      #Fonts
      pkgs.jetbrains-mono
      pkgs.nerdfonts

      # Compilers/Interpreters
      pkgs.lua
      pkgs.nodejs
      unstable.nil

      # Terminal Emulators
      pkgs.kitty
      unstable.wezterm
  ];

  # Need this with appindicator https://nixos.wiki/wiki/GNOME
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

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
  system.stateVersion = "22.05"; # Did you read the comment?
  
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
      sysadmin = "sudo cp /etc/nixos/configuration.nix $HOME/Developer/nixos/ && sudo cp /etc/nixos/flake.nix $HOME/Developer/nixos/ && cd $HOME/Developer/nixos/ && git add . && EDITOR=nvim git commit && git push";
      updatedb = "sudo updatedb";
      copy = "wl-copy";
      ipython = "nix-shell $HOME/Developer/NixShells/IPython/shell.nix --command ipython";
      mkJup = "docker run -v \"\${PWD}\":/home/jovyan/work -p 8888:8888 jupyter/datascience-notebook";
      nix-editor = "nix-shell --command \"subl $PWD; return\"";
      repl = "nix-shell $HOME/Developer/NixShells/ghci/shell.nix --command ghci";
    };
    
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "sudo" "fzf" "z"];
      theme = "half-life";
    };
    enableGlobalCompInit = false;

    promptInit = 
    ''
    mkMonad() {
        if [ -z "$1" ]
        then 
          echo "No argument supplied for mkMonad"
        else 
          mkdir "$1" && cd "$1" && nix-shell -p "haskellPackages.ghcWithPackages (pkgs: with pkgs; [ cabal-install ])" --run "cabal init" && cp $HOME/Developer/NixShells/HaskellBase/default.nix .
        fi
    }
    '';

    loginShellInit = 
    ''
    export ZSHZ_DATA="~/.cache/zsh/.z"
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
}
