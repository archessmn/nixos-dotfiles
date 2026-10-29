{
  config,
  lib,
  pkgs,
  hostname,
  ...
}:

let
  cfg = config.archessmn.roles.garage;
in

{
  options.archessmn.roles.garage = {
    enable = lib.mkEnableOption "garage";
    domains = {
      s3 = lib.mkOption {
        description = "Domain name used by s3 clients";
        type = lib.types.str;
      };

      web = lib.mkOption {
        description = "Root domain name used to serve web-accessible buckets.";
        type = lib.types.str;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets."garage-rpc-secret" = {
      file = ../../../secrets/${hostname}/garage/rpc-secret.age;
      group = "garage";
      mode = "440";
    };
    age.secrets."garage-admin-token" = {
      file = ../../../secrets/${hostname}/garage/rpc-secret.age;
      group = "garage";
      mode = "440";
    };

    services.garage = {
      enable = true;
      package = pkgs.garage_2;
      extraEnvironment = {
        GARAGE_ALLOW_WORLD_READABLE_SECRETS = "true";
      };
      settings = {
        replication_factor = 1;
        rpc_bind_addr = "[::]:3901";
        rpc_public_addr = "127.0.0.1:3901";
        rpc_secret_file = config.age.secrets."garage-rpc-secret".path;
        s3_api = {
          s3_region = "garage";
          api_bind_addr = "[::]:3900";
          root_domain = cfg.domains.s3;
        };
        s3_web = {
          bind_addr = "[::]:3902";
          root_domain = cfg.domains.web;
          index = "index.html";
        };
        admin = {
          api_bind_addr = "[::]:3903";
          admin_token_file = config.age.secrets."garage-admin-token".path;
        };
      };
    };

    users.groups = {
      garage = { };
    };

    users.users.archessmn.extraGroups = [ "garage" ];

    services.traefik = {
      dynamicConfigOptions = {
        http = {
          routers = {
            garage-s3 = {
              rule = "Host(`cdn.temjin.infra.archess.mn`)";
              service = "garage-s3";
            };
            garage-web = {
              rule = "Host(`static.temjin.infra.archess.mn`)";
              service = "garage-web";
            };

            archess-mn = {
              rule = "Host(`archess.mn`) || Host(`www.archess.mn`)";
              service = "garage-web";
            };
          };

          services = {
            garage-s3 = {
              loadBalancer = {
                servers = [
                  {
                    url = "http://localhost:3900";
                  }
                ];
              };
            };
            garage-web = {
              loadBalancer = {
                servers = [
                  {
                    url = "http://localhost:3902";
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
