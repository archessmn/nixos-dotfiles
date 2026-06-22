{
  lib,
  config,
  hostname,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.firefly-iii;
in
{
  options.archessmn.roles.firefly-iii = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    age.secrets.firefly_app_key.file = ../../../secrets/${hostname}/firefly_app_key.age;
    age.secrets.firefly_cron_token_env.file = ../../../secrets/${hostname}/firefly_cron_token.env.age;
    age.secrets.firefly_db_password.file = ../../../secrets/${hostname}/firefly_db_password.age;

    systemd.tmpfiles.rules = [
      "d /opt/firefly 1600 root root"
    ];

    # https://discourse.nixos.org/t/how-to-create-docker-network-in-nixos-configuration-correctly/16945/3
    system.activationScripts.mkFireflyNetwork =
      let
        docker = config.virtualisation.oci-containers.backend;
        dockerBin = "${pkgs.${docker}}/bin/${docker}";
      in
      ''
        ${dockerBin} network inspect firefly >/dev/null 2>&1 || ${dockerBin} network create firefly
      '';

    virtualisation.oci-containers = {
      backend = "docker";

      containers = {
        fireflyiii = {
          image = "fireflyiii/core:latest";
          autoStart = true;

          ports = [
            "127.0.0.1::8080"
          ];

          volumes = [
            "/opt/firefly:/var/www/html/storage/upload"
          ];

          networks = [
            "firefly"
          ];

          environment = {
            APP_ENV = "production";
            APP_KEY_FILE = config.age.secrets.firefly_app_key.path;
            SITE_OWNER = "firefly@archess.mn";
            DB_CONNECTION = "pgsql";
            DB_HOST = "master.postgres.service.consul";
            DB_PORT = "5432";
            DB_DATABASE = "firefly";
            DB_USERNAME = "firefly";
            DB_PASSWORD_FILE = config.age.secrets.firefly_db_password.path;
            TZ = "Europe/London";
          };

          environmentFiles = [
            config.age.secrets.firefly_cron_token_env.path
          ];

          labels = {
            "traefik.enable" = "true";
            "traefik.http.routers.firefly.rule" = "Host(`firefly.archess.mn`)";
          };
        };

        fireflyiii-cron = {
          image = "alpine";
          autoStart = true;

          networks = [
            "firefly"
          ];

          environmentFiles = [
            config.age.secrets.firefly_cron_token_env.path
          ];

          dependsOn = [ "fireflyiii" ];

          cmd = [
            "sh"
            "-c"
            "apk add tzdata && \
              (ln -s /usr/share/zoneinfo/$$TZ /etc/localtime || true) && \
              echo \"0 3 * * * wget -qO- http://fireflyiii:8080/api/v1/cron/$$STATIC_CRON_TOKEN;echo\" \
              | crontab - && \
              crond -f -L /dev/stdout"
          ];
        };
      };
    };
  };
}
