{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.iocaine;
in
{
  imports = [
    ./asndb-update.nix
  ];

  options.archessmn.roles.iocaine = {
    enable = mkOption {
      type = types.bool;
      default = config.archessmn.roles.traefik.enable;
    };
  };

  config = mkIf cfg.enable {
    # Nicked from https://github.com/ashhhleyyy/forest/blob/6de372155993eed04b64955ea50e8f403769bed6/modules/services/servers/web/iocaine/default.nix

    services.maxmind-db-update = {
      enable = true;
      attachTo = "iocaine";
    };

    services.iocaine = {
      enable = true;
      config = {
        initial-seed-file = "/run/current-system/boot.json";
        server.default = {
          bind = "127.0.0.1:42069";
          mode = "http";
          use.handler-from = "nsoe";
          use.metrics = "metrics";
        };
        server.metrics = {
          bind = "0.0.0.0:42042";
          mode = "prometheus";
          persist-path = "qmk-metrics.json";
          persist-interval = "1h";
        };
        handler.nsoe = {
          path = "${pkgs.nam-shub-of-enki}";
          config = {
            inherits = "default";

            ai-robots-txt-path = pkgs.fetchurl {
              url = "https://github.com/ai-robots-txt/ai.robots.txt/raw/425d1a6207992e5ead73e2dd71fd98283dc7d9b6/robots.json";
              hash = "sha256-3dUfNo8B8w4uPcbwgeSgeGI4qqsI/TWl9w7Fdthu/hc=";
            };
            checks.asn.database-path = "GeoLite2-ASN.mmdb";
            checks.custom-agents.allow = [
              "forgejo-cli/0.6.0 (https://codeberg.org/forgejo-contrib/forgejo-cli/)"
              "WhatsApp/2" # signal uses this UA for link previews
            ];

            sources = {
              training-corpus = [
                "${pkgs.callPackage ./1984.nix { }}"
                # TODO: more input material
              ];
              wordlists = [
                "${pkgs.miscfiles}/share/web2"
              ];
            };
          };
        };
      };
    };

    services.traefik = {
      staticConfigOptions = {
        entryPoints.websecure.http = {
          middlewares = [ "iocaine@file" ];
        };
        experimental.localPlugins = {
          traefik-iocaine-middleware = {
            moduleName = "git.mstar.dev/mstar/traefik-iocaine-middleware";
          };
        };
      };

      dynamicConfigOptions = {
        http = {
          middlewares = {
            iocaine = mkIf config.archessmn.roles.iocaine.enable {
              plugin.traefik-iocaine-middleware = {
                iocaineHttpUrl = "http://127.0.0.1:42069";
                methods = "GET,HEAD";
              };
            };
          };

          routers = {
            iocaine = {
              rule = "PathPrefix(`/`)";
              service = "iocaine";
            };
          };

          services = {
            iocaine = {
              loadBalancer = {
                servers = [
                  {
                    url = "http://127.0.0.1:42069";
                  }
                ];
              };
            };
          };
        };
      };
    };

    services.prometheus.scrapeConfigs = mkIf config.archessmn.roles.prometheus.enable [
      {
        job_name = "iocaine";
        static_configs = [
          {
            targets = [
              "127.0.0.1:42042"
            ];
          }
        ];
      }
    ];
  };
}
