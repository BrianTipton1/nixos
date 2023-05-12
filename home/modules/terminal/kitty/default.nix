_:
{ config, lib, pkgs, X86-LINUX, ... }: {
  options.terminal.kitty.enable = lib.mkEnableOption "terminal kitty";
  config = lib.mkIf config.terminal.kitty.enable {
    programs.kitty = {
      enable = true;
      package = pkgs.kitty;
      extraConfig = if config.wayland.enable then ''
        cursor_shape beam
        close_on_child_death yes
        linux_display_server wayland
      '' else ''
        cursor_shape beam
        close_on_child_death yes
      '';
      font.name = if pkgs.system == X86-LINUX then
        "JetBrains Mono Regular Nerd Font Complete"
      else
        "JetBrainsMono Nerd Font Mono";
      font.size = 18;
      theme = "Galaxy";
    };
  };
}
