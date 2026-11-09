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

      image = "ghcr.io/seerr-team/seerr:latest@sha256:2636191726a315dbd75228537f7be74b2fa7498998bb22e37b5b5c8756018fba";

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
