{ self, ... }@inputs:
user: host: system:

let
  config-file = import "${self}/home/configurations/${user}@${host}.nix" inputs;
  home-directory = "/home/${user}";

in inputs.home-manager.lib.homeManagerConfiguration {
  pkgs = inputs.nixpkgs.legacyPackages.${system};
  modules = builtins.attrValues self.homeModules ++ [
   ({  ... }: {
      nixpkgs.config.allowUnfreePredicate = (pkg: true);
      nixpkgs.config.allowUnfree = true;
      nixpkgs.config.useGlobalPkgs = true;
      nixpkgs.config.useUserPackages = true;
      # nixpkgs.config.extraSpecialArgs = { inherit inputs; };
    })
    config-file
    {
      home = {
        username = user;
        homeDirectory = home-directory;
        packages = [ inputs.home-manager.packages.${system}.home-manager ];
      };
    }
  ];
}
