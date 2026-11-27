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

      image = "docker.io/qmcgaw/gluetun:latest@sha256:38ca6d6ee43b756e387c28339b5e186742aff4bdfaa8f1850237a88a44180652";

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
