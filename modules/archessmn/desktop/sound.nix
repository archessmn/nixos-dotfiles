{ lib, config, pkgs, unstablePkgs, theLocale, theTimezone, ... }:
with lib;
let
  cfg = config.archessmn.desktop;
in
{
  options.archessmn.desktop = {
    doSound = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.doSound {
    # Sound stuff
    sound.enable = true;

    security.rtkit.enable = true;

    hardware.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      audio.enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      jack.enable = true;
    };
  };
}