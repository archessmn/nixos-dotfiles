{
  lib,
  config,
  pkgs,
  hostname,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.immich;

  immich-release = "v3.0.2";
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
    age.secrets.immich_env.file = ../../../secrets/${hostname}/immich.env.age;

    # https://discourse.nixos.org/t/how-to-create-docker-network-in-nixos-configuration-correctly/16945/3
    system.activationScripts.mkImmichNetwork =
      let
        docker = config.virtualisation.oci-containers.backend;
        dockerBin = "${pkgs.${docker}}/bin/${docker}";
      in
      ''
        ${dockerBin} network inspect immich >/dev/null 2>&1 || ${dockerBin} network create immich
      '';

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

          networks = [
            "immich"
          ];

          environmentFiles = [
            config.age.secrets.immich_env.path
          ];

          labels = {
            "traefik.enable" = "true";
            "traefik.http.routers.immich.rule" = "Host(`immich.moir.xyz`)";
          };
        };

        immich-machine-learning = {
          image = "ghcr.io/immich-app/immich-machine-learning:${immich-release}";
          autoStart = true;

          volumes = [
            "/var/lib/immich/model-cache:/cache"
          ];

          networks = [
            "immich"
          ];

          environmentFiles = [
            config.age.secrets.immich_env.path
          ];
        };

        immich-redis = {
          image = "docker.io/valkey/valkey:9@sha256:4963247afc4cd33c7d3b2d2816b9f7f8eeebab148d29056c2ca4d7cbc966f2d9";
          autoStart = true;

          hostname = "immich_redis";

          networks = [
            "immich"
          ];
        };

        immich-database = {
          image = "ghcr.io/immich-app/postgres:14-vectorchord0.3.0-pgvectors0.2.0";
          autoStart = true;

          hostname = "immich_postgres";

          # ports = [
          #   "5434:5432"
          # ];

          networks = [
            "immich"
          ];

          volumes = [
            "/var/lib/immich/pgdata:/var/lib/postgresql/data"
          ];

          environmentFiles = [
            config.age.secrets.immich_env.path
          ];
        };
      };
    };

  };
}
