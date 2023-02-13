{ config, pkgs, ... }: {
  imports = [ ./clean-home ];

  # KDE Services
  services.kdeconnect.enable = true;
}
