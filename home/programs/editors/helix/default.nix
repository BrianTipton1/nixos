{ config, pkgs, ... }: {
  programs.helix = {
    enable = true;
    package = pkgs.helix;
    languages = [ ];
    settings = {
      keys = builtins.fromJSON (builtins.readFile ./keybinds.json);
      theme = "ayu_mirage";
    };
  };
}
