{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.hummer;
in
{
  options.archessmn.roles.hummer = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.backend = "docker";

    virtualisation.oci-containers.containers.hummer = {
      autoStart = true;

      image = "ury-buzz:latest@sha256:73dcc7667e5e146a86707d21e7f86726b632138d88101eb5d1ee750c810ae234";

      ports = [
        "127.0.0.1::8000"
      ];

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.hummer.rule" = "Host(`ury-with.buzz`)";
      };
    };
  };
}
