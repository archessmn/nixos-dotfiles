{
  hostname,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.chdrms;
in
{
  options.archessmn.roles.chdrms = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    age.secrets.chdrms_env.file = ../../../secrets/${hostname}/chdrms/env.age;
    age.secrets.chdrms_config_toml.file = ../../../secrets/${hostname}/chdrms/config.toml.age;

    virtualisation.oci-containers.backend = "docker";

    virtualisation.oci-containers.containers.chdrms = {
      autoStart = true;

      image = "ghcr.io/ystv/chdrms:main";

      environmentFiles = [
        config.age.secrets.chdrms_env.path
      ];

      volumes = [
        "${config.age.secrets.chdrms_config_toml.path}:/config.toml"
      ];

      ports = [
        "127.0.0.1::3000"
      ];

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.chdrms.rule" = "Host(`assets.archess.mn`)";
      };
    };
  };
}
