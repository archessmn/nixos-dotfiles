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

      image = "ghcr.io/hotio/sonarr:latest@sha256:5ff414437aecc1663c3b97ebfc03df8e24291736b7f94290f7a206a1c7b91a00";

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
