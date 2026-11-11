{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.beszel.hub;
in
{
  options.archessmn.roles.beszel.hub = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d /opt/beszel-hub 1766 root root"
    ];

    virtualisation.oci-containers.backend = "docker";

    virtualisation.oci-containers.containers.beszel-hub = {
      autoStart = true;

      image = "docker.io/henrygd/beszel:latest@sha256:dd149010e30f4ba5876b6a65eb7ba3026f8c10d14dc07808d6324b02d477d93d";

      ports = [
        "8090:8090"
      ];

      environment = {
        APP_URL = "https://beszel.archess.mn";
      };

      volumes = [
        "/opt/beszel-hub:/beszel_data"
      ];

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.beszel-hub.rule" = "Host(`beszel.archess.mn`)";
      };
    };
  };
}
