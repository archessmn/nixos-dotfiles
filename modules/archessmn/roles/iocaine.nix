{
  hostname,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.iocaine;
in
{
  options.archessmn.roles.iocaine = {
    enable = mkOption {
      type = types.bool;
      default = config.archessmn.roles.traefik.enable;
    };
  };

  config = mkIf cfg.enable {
    # age.secrets.iocaine_env.file = ../../../secrets/${hostname}/iocaine/env.age;

    virtualisation.oci-containers.backend = "docker";

    virtualisation.oci-containers.containers.iocaine = {
      autoStart = true;

      image = "git.madhouse-project.org/iocaine/iocaine:latest@sha256:1a10034a000e5886f8d646233a419320a32858f27bb1124271f6dd719a026bc5";

      # environmentFiles = [
      #   config.age.secrets.iocaine_env.path
      # ];
      environment = {
        RUST_LOG = "iocaine=info";
      };

      ports = [
        "127.0.0.1:42069:42069"
      ];

      labels = {
        "traefik.http.middlewares.iocaine.plugin.iocaine.iocaineHttpUrl" = "http://iocaine:42069";
        "traefik.http.middlewares.iocaine.plugin.iocaine.methods" = "GET,HEAD";
      };
    };
  };
}
