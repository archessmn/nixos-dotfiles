{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.beszel.agent;
in
{
  options.archessmn.roles.beszel.agent = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    extraFileSystems = mkOption {
      type = types.listOf str;
      default = [ ];
    };
  };

  config = mkIf cfg.enable {

    age.secrets.beszel_key = {
      file = ../../../../secrets/beszel_key.age;

      mode = "644";
    };

    services.beszel.agent = {
      enable = true;

      environment = {
        KEY_FILE = config.age.secrets.beszel_key.path;
        EXTRA_FILESYSTEMS = strings.concatStrings strings.intersperse "," cfg.extraFileSystems;
      };
    };
  };
}
