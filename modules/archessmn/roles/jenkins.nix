{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.jenkins;
in
{
  options.archessmn.roles.jenkins = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.jenkins = {
      enable = true;
      port = 6000;
    };
  };
}
