{ pkgs, ... }:
let
  mkStartScript = pkgs.writeShellScript "start.sh" ''
    while :
    do
      [[ $(${pkgs.pulseaudio}/bin/pacmd list-cards) =~ "alsa_input.usb-Blue_Microphones_Yeti_Nano_8838B13699040506" ]] && break
    done
    ${pkgs.pulseaudio}/bin/pactl set-default-source alsa_input.usb-Blue_Microphones_Yeti_Nano_8838B13699040506-00.analog-stereo
    ${pkgs.noisetorch}/bin/noisetorch -i
    ${pkgs.pulseaudio}/bin/pactl set-default-source nui_mic_remap
  '';
in {
  systemd.user.services.noisetorch = {
    Unit = { Description = "Auto start noisetorch on boot"; };
    Service = {
      ExecStart = "${mkStartScript}";
      Type = "oneshot";
      RemainAfterExit = "true";
    };
    Install = { WantedBy = [ "default.target" ]; };
  };
}
