{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.arr.readarr;
in
{
  options.archessmn.roles.arr.readarr = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.backend = "docker";

    virtualisation.oci-containers.containers.readarr = {
      autoStart = true;

      image = "ghcr.io/hotio/readarr:testing-0.4.18.2805";

      volumes = [
        "/opt/readarr/config:/config"
        "/deep-storage-pool:/data"
      ];

      ports = [
        "8787:8787"
      ];

      environment = {
        PUID = "1000";
        PGID = "1";
        UMASK = "002";
        TZ = "Etc/UTC";
      };

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.readarr.rule" = "Host(`readarr.moir.xyz`)";
      };
    };
  };
}
