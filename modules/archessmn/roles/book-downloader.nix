{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.book-downloader;

  gluetunContainerName = "gluetun";
in
{
  options.archessmn.roles.book-downloader = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      backend = "docker";

      containers = {
        book-downloader = {
          image = "ghcr.io/calibrain/shelfmark:latest@sha256:85784338c06994740d66ff377bfa4e350baf0b8e826ef9a58ddf2d1069cbb01c";
          autoStart = true;

          networks = [
            "container:${gluetunContainerName}"
          ];

          volumes = [
            "/deep-storage-pool/bookdrop:/books"
            "/opt/book-downloader/config:/config"
          ];

          environment = {
            UID = "1000";
            GID = "1";
            TZ = "Etc/UTC";
            SEARCH_MODE = "universal";
          };
        };

      };
    };

    virtualisation.oci-containers.containers.${gluetunContainerName}.ports = [
      "8084:8084"
    ];

    systemd.services."docker-book-downloader" = {
      after = [ "docker-${gluetunContainerName}.service" ];
      requires = [ "docker-${gluetunContainerName}.service" ];
      bindsTo = [ "docker-${gluetunContainerName}.service" ];
      partOf = [ "docker-${gluetunContainerName}.service" ];
    };
  };
}
