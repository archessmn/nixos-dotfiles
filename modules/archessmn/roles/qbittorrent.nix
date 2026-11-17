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

      image = "ghcr.io/linuxserver/qbittorrent:latest@sha256:c848051844a2e2c34e557cafe74f548fe46b3fa27560e3af95904c3a51284b2b";

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

    virtualisation.oci-containers.containers.${gluetunContainerName}.ports = mkMerge [
      [
        "49893:49893"
      ]
      (mkIf config.archessmn.roles.prometheus.enable [
        "127.0.0.1:8090:8090"
        "[::1]:8090:8090"
      ])
    ];

    systemd.services."docker-qbittorrent" = {
      after = [ "docker-${gluetunContainerName}.service" ];
      requires = [ "docker-${gluetunContainerName}.service" ];
      bindsTo = [ "docker-${gluetunContainerName}.service" ];
      partOf = [ "docker-${gluetunContainerName}.service" ];
    };

    age.secrets.qbittorrent_exporter_env.file = mkIf config.archessmn.roles.prometheus.enable (
      ../../../secrets/${hostname}/qbittorrent-exporter.env.age
    );

    virtualisation.oci-containers.containers.qbittorrent-exporter =
      mkIf config.archessmn.roles.prometheus.enable
        {
          autoStart = true;

          image = "ghcr.io/martabal/qbittorrent-exporter:latest@sha256:9289fc5ad5cef7af6af5af5ab5ed7b8d609827490ba374df858905d66da7ec5f";

          networks = [
            "container:${gluetunContainerName}"
          ];

          environmentFiles = [
            config.age.secrets.qbittorrent_exporter_env.path
          ];
        };

    systemd.services."docker-qbittorrent-exporter" = {
      after = [ "docker-${gluetunContainerName}.service" ];
      requires = [ "docker-${gluetunContainerName}.service" ];
      bindsTo = [ "docker-${gluetunContainerName}.service" ];
      partOf = [ "docker-${gluetunContainerName}.service" ];
    };

    services.prometheus.scrapeConfigs = mkIf config.archessmn.roles.prometheus.enable [
      {
        job_name = "qbittorrent";
        static_configs = [
          {
            targets = [
              "localhost:8090"
            ];
          }
        ];
      }
    ];
  };
}
