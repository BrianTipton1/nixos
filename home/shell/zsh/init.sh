mkMonad() {
    if [ -z "$1" ]; then
        echo "No argument supplied for mkMonad"
    else
        mkdir "$1" && cd "$1" && nix-shell -p "haskellPackages.ghcWithPackages (pkgs: with pkgs; [ cabal-install ])" --run "cabal init" && cp $HOME/Developer/NixShells/HaskellBase/default.nix .
    fi
}

pdfReverse(){
    if [ -z "$1" ]; then
        echo "No argument supplied for pdfReverse"
    else
        NAME=$(echo "$1" | sed -e 's/.pdf$//g')
        echo "$NAME"
        pdftk "$NAME".pdf cat end-1 output "$NAME"_REVERSED.pdf
    fi
}

# emacs() {
#     if [ -z "$1" ]; then
#         emacs > /dev/null 2>&1
#     else
#         emacs "$@" > /dev/null 2>&1
#     fi
# }
