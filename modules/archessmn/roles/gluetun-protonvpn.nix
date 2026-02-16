{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.gluetun-protonvpn;
in
{
  options.archessmn.roles.gluetun-protonvpn = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.backend = "docker";

    systemd.tmpfiles.rules = [
      "d /opt/gluetun-protonvpn 1600 root root"
    ];

    virtualisation.oci-containers.containers.gluetun-protonvpn = {
      autoStart = true;

      image = "qmcgaw/gluetun:v3.41.0";

      capabilities = {
        NET_ADMIN = true;
      };

      volumes = [
        "/opt/gluetun-protonvpn:/gluetun"
      ];

      environmentFiles = [
        config.age.secrets.gluetun-protonvpn_env.path
      ];
    };
  };
}
