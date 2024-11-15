{ lib, config, pkgs, unstablePkgs, theLocale, theTimezone, username, ... }:
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
