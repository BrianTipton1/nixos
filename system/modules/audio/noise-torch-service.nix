{ pkgs, lib, config, ... }:
with lib; {
  options.audio = {
    noise-torch-input = mkOption {
      default = "";
      description = ''
        The audio input device that noise torch service automatically starts with
      '';
    };
  };
  config = (mkIf (config.audio.noise-torch-input != "") {
    systemd.user.services.noisetorch = let
      mkStartScript = pkgs.writeShellScript "start.sh" ''
        while :
        do
          [[ $(${pkgs.pulseaudio}/bin/pacmd list-cards) =~ "${config.audio.noise-torch-input}" ]] && break
        done
        ${pkgs.pulseaudio}/bin/pactl set-default-source ${config.audio.noise-torch-input}
        ${pkgs.noisetorch}/bin/noisetorch -i
        ${pkgs.pulseaudio}/bin/pactl set-default-source nui_mic_remap
      '';
    in {
      enable = true;
      description = "Auto start noisetorch on boot";
      serviceConfig = {
        ExecStart = "${mkStartScript}";
        Type = "oneshot";
        RemainAfterExit = "true";
      };
      wantedBy = [ "default.target" ];
    };
  });
}
