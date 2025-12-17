{
  lib,
  config,
  pkgs,
  unstable-pkgs,
  username,
  hostname,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.immich;

  immich-release = "v2.3.1";
in
{
  options.archessmn.roles.immich = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    uploadLocation = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    age.secrets.immich_env.file = ../../../secrets/${hostname}_immich.env.age;

    virtualisation.oci-containers = {
      backend = "docker";

      containers = {
        immich-server = {
          image = "ghcr.io/immich-app/immich-server:${immich-release}";
          autoStart = true;

          ports = [
            "2283:2283"
          ];

          volumes = [
            "${cfg.uploadLocation}:/usr/src/app/upload"
            "/etc/localtime:/etc/localtime:ro"
            # "/stuff:/stuff:ro"
          ];

          environmentFiles = [
            config.age.secrets.immich_env.path
          ];
        };

        immich-machine-learning = {
          image = "ghcr.io/immich-app/immich-machine-learning:${immich-release}";
          autoStart = true;

          volumes = [
            "/var/lib/immich/model-cache:/cache"
          ];

          environmentFiles = [
            config.age.secrets.immich_env.path
          ];
        };

        redis = {
          image = "redis:6.2-alpine@sha256:51d6c56749a4243096327e3fb964a48ed92254357108449cb6e23999c37773c5";
          autoStart = true;
        };

        database = {
          image = "ghcr.io/immich-app/postgres:14-vectorchord0.3.0-pgvectors0.2.0";
          autoStart = true;

          ports = [
            "5434:5432"
          ];

          volumes = [
            "/var/lib/immich/pgdata:/var/lib/postgresql/data"
          ];

          environment = {
            POSTGRES_PASSWORD = "\${DB_PASSWORD}";
            POSTGRES_USER = "\${DB_USERNAME}";
            POSTGRES_DB = "\${DB_DATABASE_NAME}";
          };
        };
      };
    };

  };
}
