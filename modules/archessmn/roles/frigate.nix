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
  cfg = config.archessmn.roles.frigate;
in
{
  options.archessmn.roles.frigate = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.backend = "docker";

    virtualisation.oci-containers.containers.frigate = {
      autoStart = true;

      image = "ghcr.io/blakeblackshear/frigate:0.16.3";

      ports = [
        "5000:5000"
      ];

      devices = [
        "/dev/apex_0:/dev/apex_0"
        "/dev/apex_1:/dev/apex_1"
      ];

      volumes = [
        "/etc/localtime:/etc/localtime:ro"
        "/deep-storage-pool/frigate/config:/config"
        "/deep-storage-pool/frigate/new-media:/media/frigate"
        "tmpfs:/tmp/cache:rw,size=1G,exec"
      ];

      # labels = {
      #   "traefik.http.routers.kanidm.rule" = "Host(`idm.archess.mn`)";
      #   "traefik.http.services.kanidm.loadbalancer.server.port" = "8443";
      #   "traefik.http.services.kanidm.loadbalancer.server.scheme" = "https";
      # };
    };
  };
}
