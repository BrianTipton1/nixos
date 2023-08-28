_:
{ config, lib, pkgs, ... }:
let
  my-ghc = pkgs.ghc;
  ghc-with-packages = my-ghc.withPackages (pkgs: with pkgs; [ pretty-simple ]);
in {
  options.interpreters.ghci.enable = lib.mkEnableOption "interpreters ghci";

  config = lib.mkIf config.interpreters.ghci.enable {
    home.packages = [ ghc-with-packages pkgs.ghcid ];
    home.file.".ghci".text = ''
      :set -interactive-print=Text.Pretty.Simple.pPrint
      :set prompt "\ESC[34m\STX λ: \ESC[m\STX"
      :set prompt-cont "\ESC[34m\STX λ| \ESC[m\STX"
    '';
  };
}
