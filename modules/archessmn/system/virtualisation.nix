{ lib, config, pkgs, username, ... }:
with lib;
let
  cfg = config.archessmn.system;
in
{
  options.archessmn.system = {
    docker = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkMerge [
    (mkIf cfg.docker {
      virtualisation.docker.enable = true;

      users.users.${username}.extraGroups = [ "docker" ];
    })
  ];
}
