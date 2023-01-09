{ config, pkgs, ... }: {
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
      sysadmin =
        "cd /etc/nixos/ && sudo rm -rf configuration.nix home/ flake.nix && cd $HOME/Developer/nixos/ && sudo cp -r * /etc/nixos/ && sudo nixos-rebuild switch --verbose";
      sysedit = "cd $HOME/Developer/nixos/ && code .";
      sysboot =
        "cd /etc/nixos/ && sudo rm -rf configuration.nix home/ flake.nix && cd $HOME/Developer/nixos/ && sudo cp -r * /etc/nixos/ && sudo nixos-rebuild boot --verbose";
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
      trashMan = "sudo nix-collect-garbage -d; nix-collect-garbage -d;";
      dockerPurge =
        "docker rm -f $(docker ps -a -q);docker volume rm $(docker volume ls -q);docker system prune -a;";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "fzf" "z" ];
      theme = "af-magic";
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
