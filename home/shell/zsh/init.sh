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

pdfPrint(){
    if [ -z "$1" ]; then
        echo "No argument supplied for pdfPrint"
    else
        NAME=$(echo "$1" | sed -e 's/.pdf$//g')
        echo "$NAME"
        pdftk "$NAME".pdf cat end-1 output "$NAME"_REVERSED.pdf
	    lpr -P HP_OfficeJet_Pro_6970 "$NAME"_REVERSED.pdf
	    rm "$NAME"_REVERSED.pdf
    fi
}
eval "$(direnv hook zsh)"
