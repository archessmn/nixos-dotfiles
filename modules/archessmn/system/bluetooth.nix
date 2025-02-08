{
  lib,
  config,
  pkgs,
  unstable-pkgs,
  theLocale,
  theTimezone,
  ...
}:
with lib;
let
  cfg = config.archessmn.desktop;
in
{
  options.archessmn.desktop = {
    bluetooth = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.bluetooth {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
        };
      };
    };
  };
}
