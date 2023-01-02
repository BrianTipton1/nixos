{ config, pkgs, ... }: {
  programs.wezterm = {
    enable = true;
    extraConfig = let
      wezRequire = module:
        builtins.readFile (builtins.toString ./config + "/${module}.lua");
      luaConfig = builtins.concatStringsSep "\n" (map wezRequire [ "wezterm" ]);
    in ''
      ${luaConfig}
    '';
  };
}
