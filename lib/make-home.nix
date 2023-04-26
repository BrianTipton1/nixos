{ self,   ... }@inputs:
user: host: system:

let
  config-file = import "${self}/home/configurations/${user}@${host}.nix" inputs;
  home-directory =
    if (system == "aarch64-darwin") then "/Users/${user}" else "/home/${user}";
  pkgs = inputs.nixpkgs.legacyPackages.${system};

in inputs.home-manager.lib.homeManagerConfiguration {

  extraSpecialArgs = {
    inherit inputs;
    nixos = inputs.self.nixosConfigurations."${host}";
  };
  inherit pkgs;
  modules = builtins.attrValues self.homeModules ++ [
    config-file
    {
      home = {
        username = user;
        homeDirectory = home-directory;
      };
    }
  ];
}
