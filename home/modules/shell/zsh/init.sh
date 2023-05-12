mkMonad() {
	if [ -z "$1" ]; then
		echo "No argument supplied for mkMonad"
	else
		mkdir "$1" && cd "$1" && nix-shell -p "haskellPackages.ghcWithPackages (pkgs: with pkgs; [ cabal-install ])" --run "cabal init" && cp $HOME/Developer/NixShells/HaskellBase/default.nix .
	fi
}

pdfReverse() {
	if [ -z "$1" ]; then
		echo "No argument supplied for pdfReverse"
	else
		NAME=$(echo "$1" | sed -e 's/.pdf$//g')
		echo "$NAME"
		pdftk "$NAME".pdf cat end-1 output "$NAME"_REVERSED.pdf
	fi
}

pdfPrint() {
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

update_nix_input() {
	if [ -z "$1" ]; then
		echo "No argument supplied for update_nix_input"
		return 1
	fi
	if $(cd /etc/nixos/ && sudo nix flake lock --update-input $1); then
		return 0
	else
		sudo cp $HOME/Developer/nixos/flake.lock /etc/nixos && echo "Failed to update $1 input"
		return 1
	fi
}

update_stable() {
	if [ -z "$1" ]; then
		echo "No argument supplied for update_stable. options: (boot | switch)"
		return 1
	fi
	if $(update_nix_input nixpkgs-stable && sudo nixos-rebuild $1 --verbose); then
		return 0
	else
		sudo cp $HOME/Developer/nixos/flake.lock /etc/nixos && echo "Failed to update stable packages"
		return 1
	fi
}

update_nixpkgs() {
	if [ -z "$1" ]; then
		echo "No argument supplied for update_nixpkgs. options: (boot | switch)"
		return 1
	fi
	if $(update_nix_input nixpkgs && sudo nixos-rebuild $1 --verbose); then
		return 0
	else
		sudo cp $HOME/Developer/nixos/flake.lock /etc/nixos && echo "Failed to update nixpkgs packages"
		return 1
	fi
}

update_homemanager() {
	if [ -z "$1" ]; then
		echo "No argument supplied for update_homemanager. options: (boot | switch)"
		return 1
	fi
	if $(update_nix_input home-manager && sudo nixos-rebuild $1 --verbose); then
		return 0
	else
		sudo cp $HOME/Developer/nixos/flake.lock /etc/nixos && echo "Failed to update homemanager packages"
		return 1
	fi
}

fujiSearch() {
	if [ -z "$1" ]; then
		echo "No argument supplied for fujiSearch"
		return 1
	fi
	find $HOME/Documents/School/CS314/BulkDownload/ -print | grep -i ".*$1.*"
	return 0
}

function launch {
	nohup $1 >/dev/null 2>/dev/null &
	disown
}

function nixfmtdir {
	files=$(find . -type f -not -path '*/\.git/*' -name "*.nix")
	for i in $files; do
		nixfmt $i
	done
}
