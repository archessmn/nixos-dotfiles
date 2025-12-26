{
  lib,
  config,
  pkgs,
  hostname,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.booklore;
in
{
  options.archessmn.roles.booklore = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    age.secrets.booklore_env.file = ../../../secrets/${hostname}/booklore.env.age;

    # https://discourse.nixos.org/t/how-to-create-docker-network-in-nixos-configuration-correctly/16945/3
    system.activationScripts.mkBookloreNetwork =
      let
        docker = config.virtualisation.oci-containers.backend;
        dockerBin = "${pkgs.${docker}}/bin/${docker}";
      in
      ''
        ${dockerBin} network inspect booklore >/dev/null 2>&1 || ${dockerBin} network create booklore
      '';

    virtualisation.oci-containers = {
      backend = "docker";

      containers = {
        booklore = {
          image = "booklore/booklore:v1.16.0";
          autoStart = true;

          ports = [
            "6060:6060"
          ];

          volumes = [
            "/opt/booklore/data:/app/data"
            "/deep-storage-pool/media/books:/books"
            "/deep-storage-pool/bookdrop:/bookdrop"
          ];

          networks = [
            "booklore"
          ];

          environment = {
            USER_ID = "1000";
            GROUP_ID = "1";
            TZ = "Etc/UTC";
            DATABASE_USERNAME = "$DB_USER";
            DATABASE_PASSWORD = "$DB_PASSWORD";
          };

          environmentFiles = [
            config.age.secrets.booklore_env.path
          ];

          labels = {
            "traefik.enable" = "true";
            "traefik.http.routers.booklore.rule" = "Host(`books.moir.xyz`)";
          };
        };

        booklore-mariadb = {
          image = "lscr.io/linuxserver/mariadb:11.4.5";
          autoStart = true;

          hostname = "booklore_mariadb";

          networks = [
            "booklore"
          ];

          volumes = [
            "/opt/booklore/config/mariadb:/config"
          ];

          environment = {
            PUID = "1000";
            PGID = "1";
            UMASK = "002";
            TZ = "Etc/UTC";
            MYSQL_USER = "$DB_USER";
            MYSQL_PASSWORD = "$DB_PASSWORD";
          };

          environmentFiles = [
            config.age.secrets.booklore_env.path
          ];
        };
      };
    };

  };
}
