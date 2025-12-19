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

      image = "kanidm/server:1.8.5";

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
