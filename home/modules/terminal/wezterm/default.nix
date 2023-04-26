_:
{ config, lib, pkgs, ... }: {
  options.terminal.wezterm.enable = lib.mkEnableOption "terminal wezterm";
  config = lib.mkIf config.terminal.wezterm.enable {
    programs.wezterm = {
      enable = true;
      package = pkgs.stable.wezterm;
      extraConfig = let
        wezRequire = module:
          builtins.readFile (builtins.toString ./config + "/${module}.lua");
        luaConfig = builtins.concatStringsSep "\n"
          (map wezRequire [ "imports" "keys" "wezterm" ]);
      in ''
        ${luaConfig}
      '';
    };
  };
}
