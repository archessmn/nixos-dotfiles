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

      image = "ghcr.io/seerr-team/seerr:latest@sha256:ccddd8e5c5b026790b447f4c97937751083227584c793864db218b460def7959";

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
