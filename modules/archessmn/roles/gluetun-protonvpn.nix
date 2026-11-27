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

      image = "docker.io/qmcgaw/gluetun:latest@sha256:38ca6d6ee43b756e387c28339b5e186742aff4bdfaa8f1850237a88a44180652";

      capabilities = {
        NET_ADMIN = true;
      };

      volumes = [
        "/opt/gluetun-protonvpn:/gluetun"
      ];

      devices = [
        "/dev/net/tun:/dev/net/tun"
      ];

      environmentFiles = [
        config.age.secrets.gluetun-protonvpn_env.path
      ];
    };
  };
}
