_:
{ config, lib, nixos, pkgs, ... }:
let
  rm-kscreen = pkgs.writeShellScriptBin "rmKscreen" ''
    rm -rf $HOME/.local/share/kscreen
  '';
  rm-plasma = pkgs.writeShellScriptBin "rmKde" ''
    rm -rf ~/.local/share/plasma*
    rm -rf ~/.local/share/kde*
    rm -rf ~/.config/plasma*
    rm -rf ~/.config/kde*
    rm -rf ~/.cache/plasma*
    rm -rf ~/.cache/kde*
  '';
  mullvad-helper = pkgs.writeShellScriptBin "multoggle" ''
    status=$(mullvad status)
    if [[ "$status" =~ "Disconnected" ]]; then
    	mullvad lockdown-mode set on  > /dev/null 2>&1
    	mullvad connect
    	echo Connected
    else
    	mullvad lockdown-mode set off > /dev/null 2>&1
    	mullvad disconnect
    	echo Disconnected
    fi
  '';
in {
  options.scripts.enable = lib.mkEnableOption "scripts";

  config = lib.mkMerge [
    (lib.mkIf (config.scripts.enable && nixos.config.plasma.enable) {
      home.packages = [ rm-kscreen rm-plasma ];
    })
    (lib.mkIf
      (config.scripts.enable && nixos.config.services.mullvad-vpn.enable) {
        home.packages = [  mullvad-helper  ];
      })
  ];
}

