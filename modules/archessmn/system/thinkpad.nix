{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.archessmn.system.thinkpad;
in
{
  options.archessmn.system.thinkpad = {
    enable = mkEnableOption "Is ThinkPad?";
  };

  config = mkIf cfg.enable {
    # https://github.com/NixOS/nixpkgs/issues/19022
    # https://forum.manjaro.org/t/temporary-fix-for-non-working-trackpoint-on-lenovo-thinkpad-l13-g2/46509
    # echo -n "elantech" | sudo tee /sys/bus/serio/devices/serio1/protocol

    services.libinput.enable = true;

    hardware.trackpoint.enable = lib.mkDefault true;
    hardware.trackpoint.emulateWheel = lib.mkDefault config.hardware.trackpoint.enable;

    services.xserver = {
      synaptics.enable = false;

      config = ''
        Section "InputClass"
          Identifier     "Enable libinput for TrackPoint"
          MatchIsPointer "on"
          Driver         "libinput"
          Option         "ScrollMethod" "button"
          Option         "ScrollButton" "8"
        EndSection
      '';
    };
  };
}
