{
  lib,
  config,
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

      image = "ghcr.io/blakeblackshear/frigate:stable@sha256:52ee4a7b4aa403347c1f31974d4faafc7157f97933c08c905c08ec6599f4f27a";

      # ports = [
      #   "5000:5000"
      # ];

      devices = [
        "/dev/apex_0:/dev/apex_0"
        "/dev/apex_1:/dev/apex_1"
      ];

      volumes = [
        "/etc/localtime:/etc/localtime:ro"
        "/deep-storage-pool/frigate/config:/config"
        "/deep-storage-pool/frigate/new-media:/media/frigate"
      ];

      extraOptions = [
        "--shm-size"
        "128mb"
        "--mount"
        "type=tmpfs,dst=/tmp/cache,tmpfs-size=1000000000"
        "--network=host"
      ];

      # labels = {
      #   "traefik.http.routers.kanidm.rule" = "Host(`idm.archess.mn`)";
      #   "traefik.http.services.kanidm.loadbalancer.server.port" = "8443";
      #   "traefik.http.services.kanidm.loadbalancer.server.scheme" = "https";
      # };
    };
  };
}
