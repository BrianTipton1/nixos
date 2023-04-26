_:
{ config, lib, pkgs, inputs, ... }:

let
  system = pkgs.system;
  overlay-stable = final: prev: {
    stable = import inputs.nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };
  };
in {
  options.nix.unfree.enable = lib.mkEnableOption "nix unfree";
  options.nix.devenv.enable = lib.mkEnableOption "nix devenv";
  options.nix.stable-overlay.enable = lib.mkEnableOption "nix stable-overlay";
  config = lib.mkMerge [
    (lib.mkIf config.nix.unfree.enable {
      nixpkgs.config.allowUnfreePredicate = (pkg: true);
      nixpkgs.config.allowUnfree = true;
    })
    (lib.mkIf config.nix.devenv.enable {
      # Use lorri and direnv
      # services.lorri.enable = true;
      programs.direnv.enable = true;
      programs.direnv.enableZshIntegration = true;
      programs.direnv.nix-direnv.enable = true;
    })
    (lib.mkIf config.nix.stable-overlay.enable
      { nixpkgs.overlays = [ overlay-stable ]; })
  ];
}
