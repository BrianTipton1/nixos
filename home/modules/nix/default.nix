_:
{ config, lib, pkgs, ... }: {
  options.nix.unfree.enable = lib.mkEnableOption "nix unfree";
  options.nix.devenv.enable = lib.mkEnableOption "nix devenv";
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

  ];
}
