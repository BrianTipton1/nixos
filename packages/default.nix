inputs:
let pkgs = inputs.nixpkgs.legacyPackages;
in { x86_64-linux = { vfio = pkgs.x86_64-linux.callPackage ./vfio { }; }; }
