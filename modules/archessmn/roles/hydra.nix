{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.hydra;
in
{
  options.archessmn.roles.hydra = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.hydra = {
      enable = true;

      port = 6000;
      hydraURL = "http://temjin.wahoo-monster.ts.net:6000";
    };
  };
}
