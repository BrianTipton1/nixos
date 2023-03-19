{ pkgs, ... }:
let
  mkCleanScript = pkgs.writeShellScript "clean.sh" ''
    find ~ -maxdepth 1 -name '*.log*' -delete
    rm -f ~/.zcompdump-*
    rm -f ~/.z
    rm -f ~/.wget-hsts
    rm -f ~/.python_history
    rm -f ~/.bash_history
    rm -f ~/.viminfo
    rm -f ~/.node_repl_history
    rm -f ~/.lesshst
    rm -f ~/.sudo_as_admin_successful
    rm -rf ~/.npm
    rm -rf ~/.quake2rtx
  '';
in {
  systemd.user.services.clean-home = {
    Unit = { Description = "Clean up various files frome home directory"; };
    Service = { ExecStart = "${mkCleanScript}"; };
    Install = { WantedBy = [ "default.target" ]; };
  };
  systemd.user.timers.clean-home = {
    Install = { WantedBy = [ "timers.target" ]; };
    Timer = {
      OnBootSec = "5m";
      OnUnitActiveSec = "60m";
      Unit = "clean-home.service";
    };
  };
}
