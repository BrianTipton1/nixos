({ nixpkgs-stable, ... }:
  let
    system = "x86_64-linux";
    overlay-stable = final: prev: {
      stable = import nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };
    };
  in { nixpkgs.overlays = [ overlay-stable ]; })
