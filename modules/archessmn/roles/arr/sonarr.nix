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

      image = "ghcr.io/hotio/sonarr:latest@sha256:385688ce3a08474846aae3bf3fdb03d3fa6179307a34ff4645f99393baafbc8f";

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
