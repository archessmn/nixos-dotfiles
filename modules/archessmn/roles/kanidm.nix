{
  lib,
  config,
  pkgs,
  unstable-pkgs,
  username,
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

      image = "kanidm/server:1.5.0";

      ports = [
        "7004:80"
      ];

      volumes = [
        "/opt/kanidm:/data"
      ];

      # environmentFiles = [
      #   config.age.secrets.vaultwarden_env.path
      # ];

      labels = {
        "traefik.http.routers.kanidm.rule" = "Host(`idm.archess.mn`)";
      };
    };
  };
}
