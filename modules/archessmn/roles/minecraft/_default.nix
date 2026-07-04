{
  lib,
  config,
  pkgs,
  # hostname,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.minecraft;
in
{
  options.archessmn.roles.minecraft = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;
      servers.gay = {
        enable = true;
        serverProperties = {
          max-players = 2;
          motd = "Meow";
          white-list = true;
        };
        whitelist = {
          archessmn = "a2bb6157-d5e7-4d2a-9a6e-e534b0b17235";
          Empleon = "7362abdc-61bb-465a-8c4e-9744520d5bb4";
        };
        package = pkgs.fabricServers.fabric-26_2.override (old: {
          jre_headless = lib.warnIf (
            lib.versions.major old.jre_headless.version == "25"
          ) "nix-minecraft is using Java 25, override is now redundant" pkgs.openjdk25_headless;
        });
      };
    };

    services.traefik = {
      dynamicConfigOptions = {
        http = {
          routers = {
            minecraft-server-gay-map = {
              rule = "Host(`gay.eduwoem.org`)";
              service = "minecraft-server-gay-map";
            };
          };

          services = {
            minecraft-server-gay-map = {
              loadBalancer = {
                servers = [
                  {
                    url = "http://localhost:8100";
                  }
                ];
              };
            };

          };
        };
      };
    };

    users.users.archessmn.extraGroups = [
      "minecraft"
    ];
  };
}
