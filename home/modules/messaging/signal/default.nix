_:
{ config, lib, pkgs, ... }: {
  options.messaging.signal.enable = lib.mkEnableOption "messaging signal";
  options.messaging.signal.autostart.enable =
    lib.mkEnableOption "messaging signal autostart";
  config = lib.mkMerge [
    (lib.mkIf config.messaging.signal.enable {
      xdg.desktopEntries = {
        "signal-desktop" = {
          name = "Signal";
          exec =
            "signal-desktop --enable-features=UseOzonePlatform --ozone-platform=wayland --use-tray-icon %U";
          categories = [ "Network" "InstantMessaging" "Chat" ];
          icon = "signal-desktop";
          comment = "Private messaging from your desktop";
        };
      };
      home.packages = with pkgs; [ signal-desktop ];
    })

    (lib.mkIf (config.messaging.signal.autostart.enable
      && config.messaging.signal.enable) {
        xdg.configFile = {
          "autostart/signal-desktop.desktop".text = ''
            [Desktop Entry]
            Categories=Network;InstantMessaging;Chat
            Comment=Private messaging from your desktop
            Exec=signal-desktop --enable-features=UseOzonePlatform --ozone-platform=wayland --use-tray-icon --start-in-tray %U
            Icon=signal-desktop
            Name=Signal
            Terminal=false
            Type=Application
            Version=1.4
          '';
        };
      })
  ];
}
