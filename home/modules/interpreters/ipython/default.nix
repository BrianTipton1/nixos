_:
{ config, lib, pkgs, ... }:
let
  my-ipython = pkgs.python3;
  my-ipython-with-packages =
    my-ipython.withPackages (p: with p; [ ipython numpy ]);
in {
  options.interpreters.ipython.enable =
    lib.mkEnableOption "interpreters ipython";
  config = lib.mkIf config.interpreters.ipython.enable {
    home.packages = with pkgs; [ my-ipython-with-packages.pkgs.ipython ];
  };
}
