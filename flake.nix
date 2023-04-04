{
  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs.url = "/home/brian/Developer/tmp/nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-alien.url = "github:thiagokokada/nix-alien";
    mesa-git = {
      url = "https://archive.mesa3d.org/mesa-23.0.1.tar.xz";
      flake = false;
    };
    neorg-overlay.url = "github:nvim-neorg/nixpkgs-neorg-overlay";
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
