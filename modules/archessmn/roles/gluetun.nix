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
  cfg = config.archessmn.roles.gluetun;
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

      image = "qmcgaw/gluetun:v3.40.3";

      capabilities = {
        NET_ADMIN = true;
      };

      ports = [
        "49893:49893"
      ];

      environmentFiles = [
        config.age.secrets.gluetun_env.path
      ];
    };
  };
}
