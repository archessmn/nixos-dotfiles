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

      image = "docker.io/qmcgaw/gluetun:latest@sha256:5913cb8ca5d2b28573813fcfaecd40cd0a833d343a4dfcea01ce849cd2f4dae8";

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
