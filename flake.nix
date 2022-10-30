{
  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  inputs.webcord.url = "github:fufexan/webcord-flake";
  
  outputs = { self, nixpkgs, ... }@attrs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [ ./configuration.nix ];
    };
  };
}

