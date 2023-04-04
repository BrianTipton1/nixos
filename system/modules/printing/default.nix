inputs:
{ config, lib, pkgs, ... }:

with lib; {
  options.officejet-6978.enable = lib.mkEnableOption "officejet-6978";
  config = mkIf config.officejet-6978.enable {
    hardware.sane.extraBackends = [ pkgs.hplipWithPlugin ];
    hardware.sane.enable = true;
    services.avahi.enable = true;
    services.avahi.nssmdns = true;
    services.printing.drivers = [ pkgs.hplip ];
    services.printing.enable = true;
  };
}
