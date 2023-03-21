{ self, ... } @ inputs: name:

let
  config-folder = "${self}/system/configurations/${name}";
  config-file = import "${config-folder}/configuration.nix" inputs;
  hardware = "${config-folder}/hardware-configuration.nix";

in inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = builtins.attrValues self.nixosModules ++ [
    config-file
    hardware
    {
      networking.hostName = name;
      system.configurationRevision = self.rev or "dirty";
      documentation.man = {
        enable = inputs.nixpkgs.lib.mkDefault true;
        generateCaches = true;
      };
    }
  ];
}