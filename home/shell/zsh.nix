{ config, pkgs, ... }: {
  programs.zsh = {

    enable = true;
    enableSyntaxHighlighting = true;
    enableAutosuggestions = true;

    ## Aliases
    shellAliases = {
      vim = "nvim";
      vi = "nvim";
      ll = "exa --long --git --icons --no-filesize";
      ls = "exa --long --git --icons --no-filesize";
      l = "exa --long --all --git --icons --no-filesize";
      lr = "exa --long --all --git --tree --icons --no-filesize";
      ld = "exa --long --all --git --tree --icons --no-filesize --git-ignore";
      rg = "rg -i";
      cat = "bat";
      nuke = "rm -rf";
      update = "sudo nixos-rebuild switch --verbose";
      upgrade = "sudo nixos-rebuild switch --upgrade --verbose";
      # sysadmin =
      #   "sudo cp $HOME/Developer/nixos/configuration.nix /etc/nixos/configuration.nix && sudo cp $HOME/Developer/nixos/flake.nix /etc/nixos/flake.nix && sudo nixos-rebuild switch --verbose";
      sysadmin =
        "cd $HOME/Developer/nixos/ && sudo cp -r * /etc/nixos/ && sudo nixos-rebuild switch --verbose";
      sysedit = "cd $HOME/Developer/nixos/ && code .";
      updatedb = "sudo updatedb";
      copy = "xclip -selection c";
      ipython =
        "nix-shell $HOME/Developer/NixShells/IPython/shell.nix --command ipython";
      mkJup = ''
        docker run -v "''${PWD}":/home/jovyan/work -p 8888:8888 jupyter/datascience-notebook'';
      nix-editor = ''nix-shell --command "code $PWD; return"'';
      repl =
        "nix-shell $HOME/Developer/NixShells/ghci/shell.nix --command ghci";
      ns = "nix-shell";
      webcord = "flatpak run io.github.spacingbat3.webcord";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "fzf" "z" ];
      theme = "af-magic";
    };
    completionInit = false;

    initExtra = ''
      mkMonad() {
          if [ -z "$1" ]
          then 
            echo "No argument supplied for mkMonad"
          else 
            mkdir "$1" && cd "$1" && nix-shell -p "haskellPackages.ghcWithPackages (pkgs: with pkgs; [ cabal-install ])" --run "cabal init" && cp $HOME/Developer/NixShells/HaskellBase/default.nix .
          fi
      }
    '';

    loginExtra = ''
      export ZSHZ_DATA="$HOME/.cache/zsh/.z"
      # Create a cache folder for zcompdump if it isn't exists
      if [ ! -d "$HOME/.cache/zsh" ]; then
          mkdir -p $HOME/.cache/zsh
      fi
      export ZSH_COMPDUMP="$HOME/.cache/zsh/zcompdump-$HOST-$ZSH_VERSION"
    '';
  };
}