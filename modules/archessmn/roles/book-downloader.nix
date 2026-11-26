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
          image = "ghcr.io/calibrain/shelfmark:latest@sha256:cb1690b01f2ffb808efc30a6f822a46117633111efc654c9938e7d564bdcadcc";
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
