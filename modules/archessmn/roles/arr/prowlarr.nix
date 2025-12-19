{
  lib,
  config,
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
  };

  config = mkIf cfg.enable {
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
  };
}
