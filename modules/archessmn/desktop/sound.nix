{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.archessmn.desktop;
in
{
  options.archessmn.desktop = {
    doSound = mkOption {
      type = types.bool;
      default = cfg.enable;
    };
  };

  config = mkIf cfg.doSound {
    # Sound stuff
    security.rtkit.enable = true;

    services.pulseaudio.enable = false;
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
