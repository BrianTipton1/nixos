{ config, ... }: {
  programs.zsh = {

    enable = true;
    enableSyntaxHighlighting = true;
    enableAutosuggestions = true;
    dotDir = ".config/zsh";
    history.path = "${config.xdg.dataHome}/zsh/zsh_history";

    ## Aliases
    shellAliases = {
      vim = "nvim";
      vi = "nvim";
      ll = "exa --long --git --icons";
      ls = "exa --long --git --icons";
      l = "exa --long --all --git --icons";
      lt = "exa --long --all --git --tree --icons --no-filesize --git-ignore";
      rg = "rg -i";
      cat = "bat";
      nuke = "rm -rf";
      update =
        "cd $HOME/Developer/nixos && sudo nixos-rebuild switch --flake .#nyx --verbose";
      update_home =
        "cd $HOME/Developer/nixos && home-manager switch --flake .#brian@nyx --verbose";
      update_boot =
        "cd $HOME/Developer/nixos && sudo nixos-rebuild boot --flake .#nyx --verbose";
      upgrade_home =
        "cd $HOME/Developer/nixos && nix flake lock --update-input home-manager && home-manager switch --flake .#brian@nyx --verbose";
      upgrade =
        "cd $HOME/Developer/nixos && nix flake update && sudo nixos-rebuild switch --flake .#nyx --verbose";
      upgrade_boot =
        "cd $HOME/Developer/nixos && nix flake update && sudo nixos-rebuild boot --flake .#nyx --verbose";
      sysedit = "cd $HOME/Developer/nixos/ && nvim .";
      updatedb = "sudo updatedb";
      copy = "wl-copy";
      ipython =
        "nix-shell $HOME/Developer/NixShells/IPython/shell.nix --command ipython";
      mkJup = ''
        docker run -v "''${PWD}":/home/jovyan/work -p 8888:8888 jupyter/datascience-notebook'';
      nix-editor = ''nix-shell --command "code $PWD; return"'';
      repl =
        "nix-shell $HOME/Developer/NixShells/ghci/shell.nix --command ghci";
      ns = "nix-shell";
      trashMan = "sudo nix-collect-garbage -d; nix-collect-garbage -d;";
      dockerPurge =
        "docker rm -f $(docker ps -a -q);docker volume rm $(docker volume ls -q);docker system prune -a;";
      fujiSync = "cd $HOME/Developer/WebServerDownload/ && python main.py";
      fujiHome =
        "xdg-open $HOME/Documents/School/CS314/BulkDownload/html/CS314_SEC1.html";
      fujiPdf = "xdg-open $HOME/Documents/School/CS314/BulkDownload/pdf/";
      fujiPpt = "xdg-open $HOME/Documents/School/CS314/BulkDownload/ppt/";
      fujiWord = "xdg-open $HOME/Documents/School/CS314/BulkDownload/doc/";
      fujiTxt = "xdg-open $HOME/Documents/School/CS314/BulkDownload/txt/";
      fujiCpp = "xdg-open $HOME/Documents/School/CS314/BulkDownload/cpp/";
      fujiHtm = "xdg-open $HOME/Documents/School/CS314/BulkDownload/htm/";
      fujiSelect =
        "find $HOME/Documents/School/CS314/BulkDownload/ -print | fzf | xargs xdg-open &>/dev/null";
      fujiClean = "pkill -9 -f p2_941; ipcrm --all=shm; ipcrm --all=sem";
      fujiRun = "nix run; fujiClean";
      open = "xdg-open";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "fzf" "z" ];
      theme = "gianu";
    };

    initExtra = builtins.readFile ./init.sh;

    loginExtra = ''
      # Create a cache folder for zcompdump if it isn't exists
      if [ ! -d "$HOME/.cache/zsh" ]; then
          mkdir -p $HOME/.cache/zsh
      fi
      export ZSHZ_DATA="$HOME/.cache/zsh/.z"
      # export ZSH_COMPDUMP="$HOME/.cache/zsh/zcompdump-$HOST-$ZSH_VERSION"
    '';
  };
}
