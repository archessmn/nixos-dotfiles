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
  cfg = config.archessmn.roles.uptime-kuma;
in
{
  options.archessmn.roles.uptime-kuma = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {

    systemd.tmpfiles.rules = [
      "d /opt/uptime-kuma 1766 root root"
    ];

    virtualisation.oci-containers.backend = "docker";

    virtualisation.oci-containers.containers.uptime-kuma = {
      autoStart = true;

      image = "louislam/uptime-kuma:1.23.16";

      ports = [
        "3001:3001"
      ];

      volumes = [
        "/opt/uptime-kuma:/app/data"
        "/var/run/docker.sock:/var/run/docker.sock"
      ];

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.uptime-kuma.rule" = "Host(`uptime.archess.mn`) || Host(`status.archess.mn`)";
      };
    };
  };
}
