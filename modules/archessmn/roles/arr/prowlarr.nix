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

        image = "ghcr.io/hotio/prowlarr:latest@sha256:8d3f29a7d774650c550ede493f164aee20e4baa735a16643065d068806c33699";

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

        image = "ghcr.io/onedr0p/exportarr:latest@sha256:89c48c73e5285bfd707afcf02d5d8d6dcfc1d955aa7160d08145654b4bc8dfbc";

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
