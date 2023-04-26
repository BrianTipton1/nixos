_:
{ config, lib, pkgs, ... }: {
  options.editors.obsidian.enable = lib.mkEnableOption "editors obsidian";

  config = lib.mkIf config.editors.obsidian.enable {
    home.packages = with pkgs; [ obsidian ];
    xdg.desktopEntries = {
      obsidian = {
        name = "Obsidian";
        exec =
          "obsidian %U --enable-features=UseOzonePlatform --ozone-platform=wayland";
        icon = "obsidian";
      };
    };
  };
}
