{
  lib,
  config,
  hostname,
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
    age.secrets.grafana_secret_key = {
      file = ../../../secrets/${hostname}/grafana_secret_key.age;
      owner = "grafana";
    };

    services.grafana = {
      enable = true;

      settings = {
        server = {
          root_url = "https://grafana.moir.xyz";
          http_addr = "0.0.0.0";
          http_port = 7000;
        };
        security = {
          secret_key = "$__file{${config.age.secrets.grafana_secret_key.path}}";
        };
      };
    };
  };
}
