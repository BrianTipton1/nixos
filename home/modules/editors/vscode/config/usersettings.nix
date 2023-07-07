pkgs: {

  window.zoomLevel = 3;
  files.autoSave = "afterDelay";
  vim.vimrc.enable = true;
  vim.vimrc.path = "~/.vsvimrc";
  workbench.colorTheme = "Ayu Mirage Bordered";
  haskell.upgradeGHCup = false;
  git.autofetch = true;
  haskell.plugin.rename.config.crossModule = true;
  workbench.iconTheme = "icons";
  haskell.formattingProvider = "fourmolu";
  nix.enableLanguageServer = true;
  nix.serverPath = "nil";
  workbench.startupEditor = "none";
  vim.useCtrlKeys = false;
  editor.lineNumbers = "relative";
  nix.serverSettings = { nil = { formatting = { command = [ "nixfmt" ]; }; }; };
  editor.fontFamily = "JetBrainsMono Nerd Font Mono";
  editor.fontLigatures = true;
  editor.fontSize = 16;
  cmake.configureOnOpen = true;
  update.mode = "none";
  Lua.telemetry.enable = false;
  code-eol.highlightNonDefault = true;
  code-eol.highlightExtraWhitespace = true;
  redhat.telemetry.enabled = false;
  # "docker.dockerPath" = "${pkgs.podman}/bin/podman";
  # "dev.containers.dockerPath" = "${pkgs.podman}/bin/podman";
  # "dev.containers.dockerComposePath" =
  #   "${pkgs.podman-compose}/bin/podman-compose";
  # "docker.composeCommand" = "podman-compose";
  # "docker.environment" = {
  #   "DOCKER_HOST" = "unix:///run/user/1000/podman/podman.sock";
  # };
  "vim.enableNeovim" = true;
  "vim.neovimConfigPath" = "~/.config/nvim/init.lua";
  "vim.neovimPath" = "${pkgs.neovim}/bin/nvim";
  "vim.useSystemClipboard" = true;
  "[c]"."editor.defaultFormatter" = "ccls-project.ccls";
  "rust-analyzer.server.path" = "${pkgs.rust-analyzer}/bin/rust-analyzer";
  "extensions.ignoreRecommendations" = true;
  "[markdown]" = {
    "editor.defaultFormatter" = "DavidAnson.vscode-markdownlint";
  };
  "markdown-preview-enhanced.previewTheme" = "one-dark.css";
  "direnv.restart.automatic" = true;
  "powershell.powerShellAdditionalExePaths" = {
    "powershell" = "/home/brian/.nix-profile/bin/pwsh";
  };
}
