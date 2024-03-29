_:
{ config, lib, pkgs, ... }:
let
  base-extensions = with pkgs.vscode-extensions;
    [
      ms-vscode.PowerShell
      ms-azuretools.vscode-docker
      vscodevim.vim
      bungcip.better-toml
      jnoortheen.nix-ide
      codezombiech.gitignore
      ms-python.python
      sumneko.lua
      catppuccin.catppuccin-vsc
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
in {
  options.editors.vscode.enable = lib.mkEnableOption "editors vscode";

  config = lib.mkIf config.editors.vscode.enable {
    programs.vscode = {
      enable = false;
      # enableUpdateCheck = false;
      package = if pkgs.system == "x86_64-linux" then
      pkgs.vscode
        # (ps:
        #   with ps; [
        #     pkgs.nil
        #     nixfmt
        #     sumneko-lua-language-server
        #     dotnet-sdk_7
        #   ])
      else
        pkgs.stable.vscode;
      extensions = if pkgs.system == "x86_64-linux" then
        with pkgs.vscode-extensions;
        [
          haskell.haskell
          vadimcn.vscode-lldb
          mads-hartmann.bash-ide-vscode
          foxundermoon.shell-format
        ] ++ base-extensions
      else
        [ ] ++ base-extensions;
      # keybindings = import ./config/keybindings.nix;
      # userSettings = import ./config/usersettings.nix pkgs;
    };
    home.file.".vsvimrc".text = ''
      imap jj <Esc>
    '';
  };
}
