inputs:
{ config, lib, pkgs, ... }:

with lib;

{
  imports = [ ./noise-torch-service.nix ];
  options.audio.enable = mkEnableOption "audio";
  config = (mkIf config.audio.enable {
    sound.enable = true;
    hardware.pulseaudio.enable = true;
    hardware.pulseaudio.support32Bit = true;
    programs.noisetorch.enable = true;
  });
}
