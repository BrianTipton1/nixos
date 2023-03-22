{ self, ... }@inputs:
user: host: system:

let
  config-file = import "${self}/home/configurations/${user}@${host}.nix" inputs;
  home-directory = "/home/${user}";
  pkgs = inputs.nixpkgs.legacyPackages.${system};

in inputs.home-manager.lib.homeManagerConfiguration {
  extraSpecialArgs = { inherit inputs; };
  inherit pkgs;
  modules = builtins.attrValues self.homeModules ++ [

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
