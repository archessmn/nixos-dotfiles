{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.prometheus;
in
{
  options.archessmn.roles.prometheus = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.prometheus = {
      enable = true;
    };
  };
}
