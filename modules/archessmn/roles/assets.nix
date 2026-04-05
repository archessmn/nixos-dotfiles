{
  hostname,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.assets;
in
{
  options.archessmn.roles.assets = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    age.secrets.assets_env.file = ../../../secrets/${hostname}/assets.env.age;

    virtualisation.oci-containers.backend = "docker";

    virtualisation.oci-containers.containers.assets = {
      autoStart = true;

      image = "ghcr.io/archessmn/assets:18";

      environmentFiles = [
        config.age.secrets.assets_env.path
      ];

      ports = [
        "127.0.0.1::3000"
      ];

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.assets.rule" = "Host(`assets.archess.mn`)";
      };
    };
  };
}
