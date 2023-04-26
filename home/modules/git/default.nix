_:
{ config, lib, pkgs, ... }: {
  options.git.enable = lib.mkEnableOption "git";
  config = lib.mkIf config.git.enable {
    programs.git = {
      enable = true;
      userName = "Brian Tipton";
      userEmail = "briantiptondev@gmail.com";
    };
  };
}
