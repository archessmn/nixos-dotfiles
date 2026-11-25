{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.gluetun;
  roles = config.archessmn.roles;
in
{
  options.archessmn.roles.gluetun = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.backend = "docker";

    systemd.tmpfiles.rules = [
      "d /opt/gluetun 1600 root root"
    ];

    virtualisation.oci-containers.containers.gluetun = {
      autoStart = true;

      image = "docker.io/qmcgaw/gluetun:latest@sha256:bf3e6920e020967cc7fefd1100ea2b463d299c1cabb209a77140824d9198f6df";

      capabilities = {
        NET_ADMIN = true;
      };

      volumes = [
        "/opt/gluetun:/gluetun"
      ];

      devices = [
        "/dev/net/tun:/dev/net/tun"
      ];

      ports = (
        mkMerge [
          (mkIf roles.arr.prowlarr.enable [ "9696:9696" ])
        ]
      );

      environmentFiles = [
        config.age.secrets.gluetun_env.path
      ];
    };
  };
}
