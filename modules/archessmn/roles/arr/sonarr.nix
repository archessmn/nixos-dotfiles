{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.arr.sonarr;
in
{
  options.archessmn.roles.arr.sonarr = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.backend = "docker";

    virtualisation.oci-containers.containers.sonarr = {
      autoStart = true;

      image = "ghcr.io/hotio/sonarr:release-4.0.16.2944";

      volumes = [
        "/opt/sonarr/config:/config"
        "/deep-storage-pool:/data"
      ];

      ports = [
        "8989:8989"
      ];

      environment = {
        PUID = "1000";
        PGID = "1";
        UMASK = "002";
        TZ = "Etc/UTC";
      };

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.sonarr.rule" = "Host(`sonarr.moir.xyz`)";
      };
    };
  };
}
