_:
{ config, lib, pkgs, ... }: {
  options.terminal.kitty.enable = lib.mkEnableOption "terminal kitty";
  config = lib.mkIf config.terminal.kitty.enable {
    programs.kitty = {
      enable = true;
      package = pkgs.kitty;
      extraConfig = ''
        KITTY_ENABLE_WAYLAND=1
        cursor_shape beam
        close_on_child_death yes
      '';
      font.name = "JetBrains Mono Regular Nerd Font Complete";
      font.size = 18;
      theme = "Galaxy";
    };
  };
}
