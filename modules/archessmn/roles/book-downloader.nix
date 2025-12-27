{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.book-downloader;
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
          image = "ghcr.io/calibrain/calibre-web-automated-book-downloader:v0.4.0";
          autoStart = true;

          ports = [
            "8084:8084"
          ];

          volumes = [
            "/deep-storage-pool/bookdrop:/cwa-book-ingest"
            "/opt/book-downloader/config:/config"
          ];

          environment = {
            UID = "1000";
            GID = "1";
            TZ = "Etc/UTC";
            SEARCH_MODE = "universal";
          };

          # labels = {
          #   "traefik.enable" = "true";
          #   "traefik.http.routers.book-downloader.rule" = "Host(`books.moir.xyz`)";
          #   "traefik.http.services.book-downloader.loadbalancer.server.port" = "6060";
          # };
        };
      };
    };

  };
}
