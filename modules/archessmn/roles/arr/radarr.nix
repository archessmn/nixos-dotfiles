{
  lib,
  config,
  hostname,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.arr.radarr;
in
{
  options.archessmn.roles.arr.radarr = {
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

      virtualisation.oci-containers.containers.radarr = {
        autoStart = true;

        image = "ghcr.io/hotio/radarr:release-6.0.4.10291";

        volumes = [
          "/opt/radarr/config:/config"
          "/deep-storage-pool:/data"
        ];

        ports = [
          "7878:7878"
        ];

        environment = {
          PUID = "1000";
          PGID = "1";
          UMASK = "002";
          TZ = "Etc/UTC";
        };

        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.radarr.rule" = "Host(`radarr.moir.xyz`)";
        };
      };
    }
    (mkIf cfg.exporter.enable {
      age.secrets.radarr_api_key.file = ../../../../secrets/${hostname}/arr/radarr_api_key.env.age;

      virtualisation.oci-containers.containers.radarr-exporter = {
        autoStart = true;

        image = "ghcr.io/onedr0p/exportarr:v2.3.0";

        ports = [
          "7879:7879"
        ];

        environment = {
          PORT = "7879";
          URL = "http://10.0.0.10:7878";
        };

        environmentFiles = [
          config.age.secrets.radarr_api_key.path
        ];

        cmd = [
          "radarr"
        ];
      };

      services.prometheus.scrapeConfigs = mkIf config.archessmn.roles.prometheus.enable [
        {
          job_name = "radarr";
          static_configs = [
            { targets = [ "localhost:7879" ]; }
          ];
        }
      ];
    })
  ]);
}
