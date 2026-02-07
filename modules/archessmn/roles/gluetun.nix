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

    virtualisation.oci-containers.containers.gluetun = {
      autoStart = true;

      image = "qmcgaw/gluetun:v3.41.0";

      capabilities = {
        NET_ADMIN = true;
      };

      ports = (
        mkMerge [
          (mkIf roles.arr.prowlarr.enable [ "9696:9696" ])
          (mkIf roles.qbittorrent.enable [ "49893:49893" ])
        ]
      );

      environmentFiles = [
        config.age.secrets.gluetun_env.path
      ];
    };
  };
}
