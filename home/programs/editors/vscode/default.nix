{ config, pkgs, ... }: {
  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    package = pkgs.unstable.vscode.fhsWithPackages
      (ps: with ps; [ pkgs.unstable.nil nixfmt sumneko-lua-language-server ]);
    extensions = with pkgs.vscode-extensions;
      [
        ms-azuretools.vscode-docker
        vscodevim.vim
        bungcip.better-toml
        jnoortheen.nix-ide
        vadimcn.vscode-lldb
        codezombiech.gitignore
        ms-python.python
        sumneko.lua
        catppuccin.catppuccin-vsc
        haskell.haskell
        mads-hartmann.bash-ide-vscode
        foxundermoon.shell-format
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "ayu";
          publisher = "teabyii";
          version = "1.0.5";
          sha256 = "sha256-+IFqgWliKr+qjBLmQlzF44XNbN7Br5a119v9WAnZOu4=";
        }
        {
          name = "icons";
          publisher = "tal7aouy";
          version = "3.6.1";
          sha256 = "sha256-TE/xxfzriWKsfmaEG8GgCYvNQTAl+sfYTjKdVZRrRvM=";
        }
        {
          name = "remote-containers";
          publisher = "ms-vscode-remote";
          version = "0.269.0";
          sha256 = "sha256-8HY46AKbAU5W01BN4iwCUSFqTXfRbC937Gy0kvPTmn4=";
        }
      ];
    keybindings = import ./config/keybindings.nix;
    userSettings = import ./config/usersettings.nix;
  };
  home.file.".vsvimrc".text = ''
    imap jj <Esc>
  '';
}
