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
  cfg = config.archessmn.roles.qbittorrent;
in
{
  options.archessmn.roles.qbittorrent = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.backend = "docker";

    virtualisation.oci-containers.containers.qbittorrent = {
      autoStart = true;

      image = "lscr.io/linuxserver/qbittorrent:5.1.4";

      volumes = [
        "/opt/qbittorrent/config:/config"
        "/deep-storage-pool/qbittorrent-data:/downloads"
      ];

      networks = [
        "container:gluetun"
      ];

      environmentFiles = [
        config.age.secrets.qbittorrent_env.path
      ];

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.qbittorrent.rule" = "Host(`qbt.moir.xyz`)";
        "traefik.http.services.qbittorrent.loadbalancer.server.port" = "49893";
      };
    };

    systemd.services."docker-qbittorrent" = {
      after = [ "docker-gluetun.service" ];
      requires = [ "docker-gluetun.service" ];
      bindsTo = [ "docker-gluetun.service" ];
      partOf = [ "docker-gluetun.service" ];
    };
  };
}
