{
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
}
