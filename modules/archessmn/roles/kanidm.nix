{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.kanidm;
in
{
  options.archessmn.roles.kanidm = {
    server.enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.server.enable {

    systemd.tmpfiles.rules = [
      "d /opt/kanidm 1600 root root"
    ];

    virtualisation.oci-containers.backend = "docker";

    virtualisation.oci-containers.containers.kanidm = {
      autoStart = true;

      image = "kanidm/server:1.12.0@sha256:71b6ff5a9c9c32b632894d8acef5a2afc77941b35a0aa95dcee959fe688d5ce9";

      ports = [
        "7004:8443"
      ];

      volumes = [
        "/opt/kanidm:/data"
      ];

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.kanidm.rule" = "Host(`idm.archess.mn`)";
        "traefik.http.services.kanidm.loadbalancer.server.port" = "8443";
        "traefik.http.services.kanidm.loadbalancer.server.scheme" = "https";
      };
    };
  };
}
