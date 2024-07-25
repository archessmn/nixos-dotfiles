{ lib, config, pkgs, unstablePkgs, theLocale, theTimezone, ...}:
with lib;
let
  cfg = config.desktop.testing;
in {
  options.desktop.testing = {
    doHardware = mkOption {
      type = types.bool;
      default = true;
    };

    bluetooth = mkOption {
      type = types.bool;
      default = true;
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
  };
}