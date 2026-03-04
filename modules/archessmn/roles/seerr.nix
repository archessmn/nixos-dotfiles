{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.seerr;
in
{
  options.archessmn.roles.seerr = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.backend = "docker";

    virtualisation.oci-containers.containers.seerr = {
      autoStart = true;

      image = "ghcr.io/seerr-team/seerr:v3.1.0";

      volumes = [
        "/opt/seerr/config:/app/config"
      ];

      ports = [
        "5055:5055"
      ];

      environment = {
        TZ = "Europe/London";
      };

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.seerr.rule" = "Host(`request.moir.xyz`)";
      };
    };
  };
}
