{
  lib,
  config,
  hostname,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.keycloak;
in
{
  options.archessmn.roles.keycloak = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    age.secrets.keycloak_postgres_password.file = ../../../secrets/${hostname}/keycloak_postgres_password.age;

    services.keycloak = {
      enable = true;
      settings = {
        hostname = "sso.archess.mn";
        http-port = 7007;
        http-enabled = true;
        proxy-headers = "xforwarded";
      };
      database = {
        username = "keycloak_prod";
        useSSL = false;
        name = "keycloak_prod";
        host = "master.postgres.service.consul";
        passwordFile = config.age.secrets.keycloak_postgres_password.path;
      };
    };

    services.traefik = {
      dynamicConfigOptions = {
        http = {
          routers = {
            keycloak = {
              rule = "Host(`sso.archess.mn`)";
              service = "keycloak";
            };
          };

          services = {
            keycloak = {
              loadBalancer = {
                servers = [
                  {
                    url = "http://localhost:7007";
                  }
                ];
              };
            };

          };
        };
      };
    };
  };
}
