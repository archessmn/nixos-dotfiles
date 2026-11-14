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

      image = "docker.io/qmcgaw/gluetun:latest@sha256:e1e80f4f80cb1180e647eadb6ffd57c3687930d886d1daac5a7555861846ff9e";

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
