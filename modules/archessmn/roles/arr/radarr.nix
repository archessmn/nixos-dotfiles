{
  lib,
  config,
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
  };

  config = mkIf cfg.enable {
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
  };
}
