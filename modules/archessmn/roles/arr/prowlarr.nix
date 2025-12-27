{
  lib,
  config,
  hostname,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.arr.prowlarr;
in
{
  options.archessmn.roles.arr.prowlarr = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    exporter.enable = mkOption {
      type = types.bool;
      default = cfg.enable;
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      virtualisation.oci-containers.backend = "docker";

      virtualisation.oci-containers.containers.prowlarr = {
        autoStart = true;

        image = "ghcr.io/hotio/prowlarr:release-2.3.0.5236";

        volumes = [
          "/opt/prowlarr/config:/config"
        ];

        networks = [
          "container:gluetun"
        ];

        environment = {
          PUID = "1000";
          PGID = "1";
          UMASK = "002";
          TZ = "Etc/UTC";
        };

        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.prowlarr.rule" = "Host(`prowlarr.moir.xyz`)";
          "traefik.http.services.prowlarr.loadbalancer.server.port" = "9696";
        };
      };

      systemd.services."docker-prowlarr" = {
        after = [ "docker-gluetun.service" ];
        requires = [ "docker-gluetun.service" ];
        bindsTo = [ "docker-gluetun.service" ];
        partOf = [ "docker-gluetun.service" ];
      };
    }
    (mkIf cfg.exporter.enable {
      age.secrets.prowlarr_api_key.file = ../../../../secrets/${hostname}/arr/prowlarr_api_key.env.age;

      virtualisation.oci-containers.containers.prowlarr-exporter = {
        autoStart = true;

        image = "ghcr.io/onedr0p/exportarr:v2.3.0";

        ports = [
          "9697:9697"
        ];

        environment = {
          PORT = "9697";
          URL = "http://10.0.0.10:9696";
        };

        environmentFiles = [
          config.age.secrets.prowlarr_api_key.path
        ];

        cmd = [
          "prowlarr"
        ];
      };

      services.prometheus.scrapeConfigs = mkIf config.archessmn.roles.prometheus.enable [
        {
          job_name = "prowlarr";
          static_configs = [
            { targets = [ "localhost:9697" ]; }
          ];
        }
      ];
    })
  ]);
}
