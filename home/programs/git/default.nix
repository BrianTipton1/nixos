{ config, pkgs, ... }: {
  programs.git = {
    enable = true;
    userName = "Brian Tipton";
    userEmail = "briantiptondev@gmail.com";
  };
}