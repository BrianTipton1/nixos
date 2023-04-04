inputs:
{ config, lib, pkgs, ... }:

with lib; {
  # Personal config for gaming 
  options.gaming.enable = lib.mkEnableOption "gaming";
  config = mkIf config.gaming.enable {
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
  };
}
