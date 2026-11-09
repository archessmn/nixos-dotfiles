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

      image = "ghcr.io/ystv/chdrms:pr-67@sha256:2b6ebebc97b73b5fdb82eacf51d0540c7463c800ec4d237c882f2cb4b3e50e17";

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
