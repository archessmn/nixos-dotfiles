{
  lib,
  config,
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

      image = "docker.io/owlcaribou/swurapp:sha256:3cf876be1f5d572ab51648769db31791c78abd4772cd4c5d854e613bbab75c2d";

      environmentFiles = [
        config.age.secrets.swur_env.path
      ];
    };
  };
}
