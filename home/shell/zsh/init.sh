mkMonad() {
    if [ -z "$1" ]; then
        echo "No argument supplied for mkMonad"
    else
        mkdir "$1" && cd "$1" && nix-shell -p "haskellPackages.ghcWithPackages (pkgs: with pkgs; [ cabal-install ])" --run "cabal init" && cp $HOME/Developer/NixShells/HaskellBase/default.nix .
    fi
}

# code() {
    # if [ -z "$1" ]; then
        # code > /dev/null 2>&1
    # else
        # code "$@" > /dev/null 2>&1
    # fi
# }
