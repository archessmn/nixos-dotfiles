{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.archessmn.system;
in
{
  options.archessmn.system = {
    fprintd = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.fprintd {
    services.fprintd.enable = cfg.fprintd;
  };
}
