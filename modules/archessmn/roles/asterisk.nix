# Testing Asterisk stuff

{
  hostname,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.asterisk;
in
{
  options.archessmn.roles.asterisk = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.asterisk = {
      enable = true;
    };
  };
}
