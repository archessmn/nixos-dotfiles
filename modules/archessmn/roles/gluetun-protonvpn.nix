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

      image = "docker.io/qmcgaw/gluetun:latest@sha256:5913cb8ca5d2b28573813fcfaecd40cd0a833d343a4dfcea01ce849cd2f4dae8";

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
