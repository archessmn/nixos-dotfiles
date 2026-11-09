{
  lib,
  config,
  hostname,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.arr.swur;
in
{
  options.archessmn.roles.arr.swur = {
    enable = mkOption {
      type = types.bool;
      default = config.archessmn.roles.arr.sonarr.enable;
    };
  };

  config = mkIf cfg.enable {
    age.secrets.swur_env.file = ../../../../secrets/${hostname}/arr/swur.env.age;

    virtualisation.oci-containers.backend = "docker";

    virtualisation.oci-containers.containers.swur = {
      autoStart = true;

      image = "ghcr.io/archessmn/swurapp:main@sha256:cbd00b54f4c2883b6ca7f0e1d8b4fb334430c3e3ee31664144920d61d3287d92@sha256:4ad5e2dcf47b007cccf7b44fc013c51e0dc82f9b30a809d49d5202a4a77d070d";

      environmentFiles = [
        config.age.secrets.swur_env.path
      ];
    };
  };
}
