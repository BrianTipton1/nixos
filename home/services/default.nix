{ config, pkgs, ... }: {
  imports = [ ./clean-home ];

  # Use lorri and direnv
  services.lorri.enable = true;

  # KDE Services
  services.kdeconnect.enable = true;
}
