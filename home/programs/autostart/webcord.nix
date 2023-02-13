{
  xdg.configFile = {
    "autostart/WebCord.desktop".text = ''
      [Desktop Entry]
      Categories=Network;Email;
      Exec=flatpak run --branch=stable --arch=x86_64 --command=run.sh io.github.spacingbat3.webcord --start-minimized --ozone-platform=wayland
      Icon=io.github.spacingbat3.webcord
      Name=WebCord
      Terminal=false
      Type=Application
      X-MultipleArgs=false
    '';
  };
  xdg.desktopEntries = {
    "WebCord" = {
      name = "WebCord";
      exec =
        "flatpak run --branch=stable --arch=x86_64 --command=run.sh io.github.spacingbat3.webcord --start-minimized --ozone-platform=wayland";
      categories = [ "Network" "Email" ];
      icon = "io.github.spacingbat3.webcord";
    };
  };

  # Tmp fix for webcord nonsense
  home.file."/home/brian/.var/app/io.github.spacingbat3.webcord/config/WebCord/windowState.json".text =
    ''
      {
          "mainWindow": {
              "width": 952,
              "height": 757.3333333333333,
              "isMaximized": true
          }
      }
    '';
  home.file."/home/brian/.var/app/io.github.spacingbat3.webcord/config/WebCord/config.json".text =
    ''
      {
          "settings": {
              "general": {
                  "menuBar": {
                      "hide": true
                  },
                  "tray": {
                      "disable": false
                  },
                  "taskbar": {
                      "flash": true
                  },
                  "window": {
                      "transparent": false,
                      "hideOnClose": true
                  }
              },
              "privacy": {
                  "blockApi": {
                      "science": true,
                      "typingIndicator": false,
                      "fingerprinting": true
                  },
                  "permissions": {
                      "video": true,
                      "audio": true,
                      "fullscreen": true,
                      "notifications": true,
                      "display-capture": true,
                      "background-sync": true
                  }
              },
              "advanced": {
                  "csp": {
                      "enabled": true
                  },
                  "cspThirdParty": {
                      "spotify": true,
                      "gif": true,
                      "hcaptcha": true,
                      "youtube": true,
                      "twitter": true,
                      "twitch": true,
                      "streamable": true,
                      "vimeo": true,
                      "soundcloud": true,
                      "paypal": true,
                      "audius": true,
                      "algolia": true,
                      "reddit": true,
                      "googleStorageApi": true
                  },
                  "currentInstance": {
                      "radio": 0
                  },
                  "devel": {
                      "enabled": false
                  },
                  "redirection": {
                      "warn": true
                  },
                  "optimize": {
                      "gpu": false
                  },
                  "webApi": {
                      "webGl": true
                  },
                  "unix": {
                      "autoscroll": false
                  }
              }
          },
          "update": {
              "notification": {
                  "version": "",
                  "till": ""
              }
          },
          "screenShareStore": {
              "audio": false
          }
      }
    '';
}
