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

      image = "ghcr.io/archessmn/monster-tracker:main@sha256:c405a6eac96fd3a458741dfcd89253f2a71a33e93bf47d5b368ccd1eef11894d";

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
