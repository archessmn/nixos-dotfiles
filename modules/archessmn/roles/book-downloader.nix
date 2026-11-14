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
          image = "ghcr.io/calibrain/shelfmark:latest@sha256:94217011ca1b743ba4ad2923fe8c435b932840dc4e4a227114c83b677b52e51c";
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
