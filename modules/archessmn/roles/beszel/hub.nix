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

      image = "henrygd/beszel:0.9.1";

      ports = [
        "8090:8090"
      ];

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
