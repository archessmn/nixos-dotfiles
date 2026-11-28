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

      image = "ghcr.io/hotio/sonarr:latest@sha256:715f4741bc1039a18e600256a6122ba775c9b03f3867659478fef8dbd039e30f";

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
