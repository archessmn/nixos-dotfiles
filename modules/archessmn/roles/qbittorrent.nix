{
  lib,
  config,
  hostname,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.qbittorrent;

  gluetunContainerName = "gluetun";
in
{
  options.archessmn.roles.qbittorrent = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    age.secrets.qbittorrent-labels.file = ../../../secrets/${hostname}/arr/qbittorrent-labels.age;

    virtualisation.oci-containers.backend = "docker";

    virtualisation.oci-containers.containers.qbittorrent = {
      autoStart = true;

      image = "lscr.io/linuxserver/qbittorrent:5.2.3";

      volumes = [
        "/opt/qbittorrent/config:/config"
        "/deep-storage-pool/qbittorrent-data:/downloads"
      ];

      networks = [
        "container:${gluetunContainerName}"
      ];

      environmentFiles = [
        config.age.secrets.qbittorrent_env.path
      ];

      extraOptions = [
        "--label-file=${config.age.secrets.qbittorrent-labels.path}"
      ];
    };

    virtualisation.oci-containers.containers.${gluetunContainerName}.ports = [
      "49893:49893"
    ];

    systemd.services."docker-qbittorrent" = {
      after = [ "docker-${gluetunContainerName}.service" ];
      requires = [ "docker-${gluetunContainerName}.service" ];
      bindsTo = [ "docker-${gluetunContainerName}.service" ];
      partOf = [ "docker-${gluetunContainerName}.service" ];
    };

    # TODO: qbittorrent-exporter
  };
}
