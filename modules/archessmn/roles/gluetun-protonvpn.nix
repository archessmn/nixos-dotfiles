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

      image = "docker.io/qmcgaw/gluetun:latest@sha256:bf3e6920e020967cc7fefd1100ea2b463d299c1cabb209a77140824d9198f6df";

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
