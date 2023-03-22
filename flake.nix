{
  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-alien.url = "github:thiagokokada/nix-alien";
    mesa-git = {
      url =
        "git+https://gitlab.freedesktop.org/mesa/mesa?rev=bbf142b8de7454a80729b2949249203c7bee7230";
      flake = false;
    };
  };

  outputs = inputs: {
    nixosConfigurations = import ./system/configurations inputs;
    nixosModules = import ./system/modules inputs;

    homeConfigurations = import ./home/configurations inputs;
    homeModules = import ./home/modules ;

    lib = import ./lib inputs;
    packages = import ./packages inputs;
  };
}
