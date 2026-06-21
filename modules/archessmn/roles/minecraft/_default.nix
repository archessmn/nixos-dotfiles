{
  lib,
  config,
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
    networking.firewall.allowedTCPPorts = [
      25565
    ];

    services.traefik = {
      staticConfigOptions = {
        entryPoints = {
          minecraft = {
            address = ":25565";
          };
        };
      };
    };

    systemd.tmpfiles.rules = [
      "d /opt/minecraft 1777 root root"
      "d /opt/minecraft/gay 1777 root root"
    ];

    virtualisation.oci-containers.containers.minecraft-gay = {
      autoStart = true;

      image = "itzg/minecraft-server";

      extraOptions = [
        "-i"
        "-t"
      ];

      environment = {
        EULA = "TRUE";
        TYPE = "FABRIC";
      };

      ports = [
        "127.0.0.1::25565"
      ];

      volumes = [
        "/opt/minecraft/gay:/data"
      ];

      labels = {
        "traefik.enable" = "true";
        "traefik.tcp.routers.minecraft-gay.rule" = "Host(`gay.eduwoem.org`)";
        "traefik.tcp.routers.minecraft-gay.entrypoints" = "minecraft";
      };
    };
  };
}
