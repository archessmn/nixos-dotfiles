{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.archessmn.system;
in
{
  options.archessmn.system = {
    fprintd = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      tod = {
        enable = mkOption {
          type = types.bool;
          default = false;
        };
        driver = mkOption {
          type = types.package;
        };
      };
    };
  };

  config = mkIf cfg.fprintd.enable {
    services.fprintd.enable = cfg.fprintd.enable;
    services.fprintd.tod = mkIf cfg.fprintd.tod.enable {
      enable = cfg.fprintd.tod.enable;
      driver = cfg.fprintd.tod.driver;
    };
  };
}
