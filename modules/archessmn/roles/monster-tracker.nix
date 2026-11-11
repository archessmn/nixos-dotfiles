{
  hostname,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.monster-tracker;
in
{
  options.archessmn.roles.monster-tracker = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    age.secrets.monster-tracker_env.file = ../../../secrets/${hostname}/monster-tracker/env.age;

    virtualisation.oci-containers.backend = "docker";

    virtualisation.oci-containers.containers.monster-tracker = {
      autoStart = true;

      image = "ghcr.io/archessmn/monster-tracker:main@sha256:c5671f47cac5d2f4eed7922c13a3234027e921a452122bdfeccd8c93b67890b4";

      environmentFiles = [
        config.age.secrets.monster-tracker_env.path
      ];

      ports = [
        "127.0.0.1::3000"
      ];

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.monster-tracker.rule" = "Host(`monster.archess.mn`)";
      };
    };
  };
}
