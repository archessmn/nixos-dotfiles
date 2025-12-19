{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.jellyseer;
in
{
  options.archessmn.roles.jellyseer = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.backend = "docker";

    virtualisation.oci-containers.containers.jellyseer = {
      autoStart = true;

      image = "fallenbagel/jellyseerr:2.7.3";

      volumes = [
        "/opt/jellyseer/config:/app/config"
      ];

      ports = [
        "5055:5055"
      ];

      environment = {
        TZ = "Europe/London";
      };

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.jellyseer.rule" = "Host(`request.moir.xyz`)";
      };
    };
  };
}
