{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.grafana;
in
{
  options.archessmn.roles.grafana = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.grafana = {
      enable = true;

      settings = {
        server = {
          root_url = "https://grafana.moir.xyz";
        };
      };
    };
  };
}
