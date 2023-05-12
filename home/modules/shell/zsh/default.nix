_:
{ config, lib, pkgs, X86-LINUX, ... }:
let
  base-aliases = {
    vim = "nvim";
    vi = "nvim";
    l = "exa --long --git --icons";
    ls = "exa";
    ll = "exa --long --all --git --icons";
    lt = "exa --long --all --git --tree --icons --no-filesize --git-ignore";
    rg = "rg -i";
    cat = "bat";
    nuke = "rm -rf";
    icat = "kitty +kitten icat";
    ns = "nix-shell";
    select = "launch $(open $(find . -type f -not -path '*/\\.git/*' | fzf))";
  };
in {
  options.shell.zsh.enable = lib.mkEnableOption "shell zsh";
  config = lib.mkIf config.shell.zsh.enable {
    programs.zsh = {

      enable = true;
      enableSyntaxHighlighting = true;
      enableAutosuggestions = true;
      dotDir = ".config/zsh";
      history.path = "${config.xdg.dataHome}/zsh/zsh_history";

      ## Aliases
      shellAliases = if pkgs.system == X86-LINUX then
        lib.mkMerge [
          ({
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
            mkJup = ''
              docker run -v "''${PWD}":/home/jovyan/work -p 8888:8888 jupyter/datascience-notebook'';
            nix-editor = ''nix-shell --command "code $PWD; return"'';
            repl =
              "nix-shell $HOME/Developer/NixShells/ghci/shell.nix --command ghci";
            trashMan = "sudo nix-collect-garbage -d; nix-collect-garbage -d;";
            dockerPurge =
              "docker rm -f $(docker ps -a -q);docker volume rm $(docker volume ls -q);docker system prune -a;";
            open = "xdg-open";
          })
          (base-aliases)
        ]
      else
        lib.mkMerge [
          (base-aliases)
          ({
            copy = "pbcopy";
            update_home =
              "cd $HOME/Developer/nixos && home-manager switch --flake .#brian@mac --verbose";
            upgrade_home =
              "cd $HOME/Developer/nixos && nix flake lock --update-input home-manager && home-manager switch --flake .#brian@mac --verbose";
          })
        ];

      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "sudo" "fzf" "z" ];
        theme = "gianu";
      };

      initExtra =
        if pkgs.system == X86-LINUX then builtins.readFile ./init.sh else "";

      loginExtra = ''
        # Create a cache folder for zcompdump if it isn't exists
        if [ ! -d "$HOME/.cache/zsh" ]; then
            mkdir -p $HOME/.cache/zsh
        fi
        export ZSHZ_DATA="$HOME/.cache/zsh/.z"
        # export ZSH_COMPDUMP="$HOME/.cache/zsh/zcompdump-$HOST-$ZSH_VERSION"
      '';
    };
  };
}
