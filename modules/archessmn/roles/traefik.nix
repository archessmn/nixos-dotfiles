{
  lib,
  pkgs,
  config,
  hostname,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.traefik;

  traefik-iocaine-middleware-plugin = pkgs.fetchgit {
    url = "https://git.mstar.dev/mstar/traefik-iocaine-middleware";
    rev = "e27e08746b3f607a388605a6e646cc366c37b2f6";
    hash = "sha256-B2g2d29jSER30OUqCkdk3+Hv5T3DA4SUKoyiqHb8FeU=";
  };
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

    networking.firewall.allowedUDPPorts = [
      443
    ];

    systemd.tmpfiles.rules = [
      "d /opt/traefik 1700 traefik traefik"
      "d /opt/traefik/plugins-local/git.mstar.dev/mstar 1700 traefik traefik"
      "L+ /opt/traefik/plugins-local/git.mstar.dev/mstar/traefik-iocaine-middleware - - - - ${traefik-iocaine-middleware-plugin}"
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
            http3 = { };
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
                propagation = {
                  delayBeforeChecks = "15s";
                };
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

        accessLog = {
          fields = {
            headers = {
              names = {
                "User-Agent" = "keep";
              };
            };
          };
        };

        experimental = {
          plugins = {
            traefik-oidc-auth = {
              moduleName = "github.com/lukaszraczylo/traefikoidc";
              version = "v0.8.24";
            };
          };
        };
      };

      dynamicConfigOptions = {
        tls.stores.default.defaultGeneratedCert = {
          resolver = "acmeresolver";
          domain = {
            main = "archess.mn";
            sans = [
              "*.archess.mn"
              "*.temjin.infra.archess.mn"
              "*.cdn.temjin.infra.archess.mn"
              "*.static.temjin.infra.archess.mn"
            ];
          };
        };

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
      ];
    };

    services.prometheus = mkIf config.archessmn.roles.prometheus.enable {
      scrapeConfigs = [
        {
          job_name = "traefik";
          static_configs = [
            {
              targets = [
                "localhost:8080"
                "tsuro.infra.archess.mn:8080"
              ];
            }
          ];
        }
      ];
    };

    users.users.traefik.extraGroups = [ "docker" ];
  };
}
