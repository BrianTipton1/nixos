_:
{ config, lib, pkgs, ... }: {
  options.interpreters.ipython.enable =
    lib.mkEnableOption "interpreters ipython";
  config = lib.mkIf config.interpreters.ipython.enable {
    home.packages = with pkgs; [ python39Packages.ipython ];
  };
}
