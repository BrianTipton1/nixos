{ config, pkgs, ... }: {
  xdg.desktopEntries = {
    mullvad = {
      name = "Mullvad VPN";
      exec = "${pkgs.mullvad-vpn} --ozone-platform-hint=auto %U";
      categories = [ "Network" ];
    };
  };
}