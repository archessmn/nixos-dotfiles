{
  lib,
  config,
  pkgs,
  unstable-pkgs,
  username,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.traefik;
in
{
  options.archessmn.roles.traefik = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    systemd.tmpfiles.rules = [
      "d /opt/traefik 1700 traefik traefik"
    ];

    # https://github.com/NixOS/nixpkgs/issues/265496
    systemd.services.traefik.serviceConfig.WorkingDirectory = "/opt/traefik";

    services.traefik = {
      enable = true;

      dataDir = "/opt/traefik";

      staticConfigOptions = {
        api = {
          insecure = true;
        };

        log = {
          filePath = "/opt/traefik/traefik.log";
          # level = "DEBUG";
        };

        serversTransport = {
          insecureSkipVerify = true;
        };

        entryPoints = {
          web = {
            address = ":80";
            http.redirections.entrypoint = {
              to = "websecure";
              scheme = "https";
              permanent = true;
            };
          };
          websecure = {
            address = ":443";
            asDefault = true;
            http = {
              tls.certresolver = "acmeresolver";
            };
          };
        };

        providers = {
          docker = { };
          consul = {
            endpoints = [
              "127.0.0.1:8500"
            ];
          };
          consulCatalog = {
            exposedByDefault = false;
          };
        };

        certificatesResolvers = {
          acmeresolver = {
            acme = {
              email = "archessmn@gmail.com";
              storage = "/opt/traefik/acme.json";
              dnsChallenge = {
                provider = "cloudflare";
              };
            };
          };
        };

        experimental = {
          plugins = {
            traefik-oidc-auth = {
              moduleName = "github.com/sevensolutions/traefik-oidc-auth";
              version = "v0.3.2";
            };
          };
        };
      };

      dynamicConfigOptions = {
        http = {
          routers = {
            dashboard = {
              rule = "Host(`traefik.tsuro.infra.archess.mn`)";
              service = "api@internal";
              middlewares = [ "oidc-auth" ];
            };
          };

          middlewares = {
            oidc-auth = {
              plugin = {
                traefik-oidc-auth = {
                  Provider = {
                    Url = "https://idm.archess.mn/oauth2/openid/tsuro-traefik";
                    ClientIdEnv = "OIDC_KANIDM_CLIENT_ID";
                    ClientSecretEnv = "OIDC_KANIDM_CLIENT_SECRET";
                    # UsePkce = true;
                  };
                  Scopes = [
                    "openid"
                    "profile"
                    "email"
                  ];
                  Headers = {
                    MapClaims = [
                      {
                        Claim = "preferred_username";
                        Header = "X-Oidc-Username";
                      }
                      {
                        Claim = "sub";
                        Header = "X-Oidc-Subject";
                      }
                    ];
                  };
                };
              };
            };
          };
        };
      };

      environmentFiles = [
        config.age.secrets.traefik_cloudflare_env.path
        config.age.secrets.traefik_kanidm_env.path
      ];
    };

    users.users.traefik.extraGroups = [ "docker" ];
  };
}
