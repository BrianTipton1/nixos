{
  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-alien.url = "github:thiagokokada/nix-alien";
    mesa-git = {
      # url = "https://archive.mesa3d.org/mesa-23.0.3.tar.xz";
      url = "https://archive.mesa3d.org/mesa-23.1.3.tar.xz";
      flake = false;
    };
    vscode-wayland-fix.url = "https://github.com/NixOS/nixpkgs/archive/55070e598e0e03d1d116c49b9eff322ef07c6ac6.tar.gz";
    podman-compose-devel.url = "github:BrianTipton1/podman-compose-flake";
    cssxpd.url = "github:BrianTipton1/cssxpd";
    hm_purge.url = "github:BrianTipton1/hm_purge";
  };

  outputs = inputs: {
    nixosConfigurations = import ./system/configurations inputs;
    nixosModules = import ./system/modules inputs;

    homeConfigurations = import ./home/configurations inputs;
    homeModules = import ./home/modules inputs;

    lib = import ./lib inputs;
    packages = import ./packages inputs;
  };
}
