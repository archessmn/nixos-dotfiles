{ lib, config, pkgs, unstablePkgs, theLocale, theTimezone, ... }:
with lib;
let
  cfg = config.archessmn.desktop;
in
{
  options.archessmn.desktop = {
    doHardware = mkOption {
      type = types.bool;
      default = true;
    };

    bluetooth = mkOption {
      type = types.bool;
      default = true;
    };

    fprintd = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.doHardware {
    # Hardware stuff

    hardware.bluetooth = mkIf cfg.bluetooth {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
        };
      };
    };

    services.usbmuxd.enable = true;

    services.fprintd.enable = cfg.fprintd;
  };
}
