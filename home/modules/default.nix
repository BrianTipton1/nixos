inputs: {
  overlay = import ./overlay inputs;
  neovim = import ./editors/neovim inputs;
  vscode = import ./editors/vscode inputs;
  emacs = import ./editors/emacs inputs;
  obsidian = import ./editors/obsidian inputs;
  git = import ./git inputs;
  ghci = import ./interpreters/ghci inputs;
  ipython = import ./interpreters/ipython inputs;
  signal = import ./messaging/signal inputs;
  zsh = import ./shell/zsh inputs;
  wezterm = import ./terminal/wezterm inputs;
  kitty = import ./terminal/kitty inputs;
  wayland = import ./wayland inputs;
  nix = import ./nix inputs;
  clean-home = import ./services/clean-home inputs;
  virtualization = import ./virtualization inputs;
}
