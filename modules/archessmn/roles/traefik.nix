{
  lib,
  config,
  hostname,
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
          docker = {
            exposedByDefault = false;
          };
          consul = {
            rootKey = "traefik/${hostname}";
            endpoints = [
              "consul.service.consul:8500"
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

          http-acmeresolver = {
            acme = {
              email = "archessmn@gmail.com";
              storage = "/opt/traefik/http-acme.json";
              httpChallenge = {
                entryPoint = "web";
              };
            };
          };
        };

        metrics = mkIf config.archessmn.roles.prometheus.enable {
          prometheus = { };
        };

        experimental = {
          plugins = {
            traefik-oidc-auth = {
              moduleName = "github.com/sevensolutions/traefik-oidc-auth";
              version = "v0.17.0";
            };
          };
        };
      };

      dynamicConfigOptions = {
        http = {
          routers = {
            dashboard = {
              rule = "Host(`traefik.${hostname}.infra.archess.mn`)";
              service = "api@internal";
              middlewares = [ "oidc-auth" ];
            };

            auth = {
              rule = "Host(`auth.${hostname}.infra.archess.mn`)";
              service = "noop@internal";
              middlewares = [ "oidc-auth" ];
            };
          };

          middlewares = {
            oidc-auth = {
              plugin = {
                traefik-oidc-auth = {
                  Secret = "\${OIDC_SECRET}";
                  Provider = {
                    Url = "https://idm.archess.mn/oauth2/openid/${hostname}-traefik";
                    ClientId = "\${OIDC_KANIDM_CLIENT_ID}";
                    ClientSecret = "\${OIDC_KANIDM_CLIENT_SECRET}";
                    UsePkce = true;
                  };
                  Scopes = [
                    "openid"
                    "profile"
                    "email"
                  ];
                  CallbackUri = "https://auth.${hostname}.infra.archess.mn/oidc/callback";
                  SessionCookie = {
                    Domain = ".${hostname}.infra.archess.mn";
                  };
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
        config.age.secrets.cloudflare_dns_env.path
        config.age.secrets.traefik_kanidm_env.path
      ];
    };

    services.prometheus = mkIf config.archessmn.roles.prometheus.enable {
      scrapeConfigs = [
        {
          job_name = "traefik";
          static_configs = [
            { targets = [ "localhost:8080" ]; }
          ];
        }
      ];
    };

    users.users.traefik.extraGroups = [ "docker" ];
  };
}
