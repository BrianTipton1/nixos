{ self, ... }@inputs:
user: host: system:

let
  ARM-DARWIN = "aarch64-darwin";
  X86-LINUX = "x86_64-linux";
  config-file = import "${self}/home/configurations/${user}@${host}.nix" inputs;
  home-directory =
    if (system == ARM-DARWIN) then "/Users/${user}" else "/home/${user}";
  pkgs = inputs.nixpkgs.legacyPackages.${system};

in inputs.home-manager.lib.homeManagerConfiguration {

  extraSpecialArgs = {
    inherit inputs;
    nixos = inputs.self.nixosConfigurations."${host}";
    ARM-DARWIN = ARM-DARWIN;
    X86-LINUX = X86-LINUX;
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
