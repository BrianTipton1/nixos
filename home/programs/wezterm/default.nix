{ config, pkgs, ... }: {
  programs.wezterm = {
    enable = true;
    package = pkgs.wezterm;
    extraConfig = let
      wezRequire = module:
        builtins.readFile (builtins.toString ./config + "/${module}.lua");
      luaConfig = builtins.concatStringsSep "\n"
        (map wezRequire [ "imports" "keys" "wezterm" ]);
    in ''
      ${luaConfig}
    '';
  };
}
