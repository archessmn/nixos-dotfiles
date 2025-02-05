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

    podman = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkMerge [
    (mkIf cfg.docker {
      virtualisation.docker.enable = true;

      users.users.${username}.extraGroups = [ "docker" ];
    })

    (mkIf cfg.podman {
      virtualisation.podman = {
        enable = true;

        dockerCompat = true;

        defaultNetwork.settings.dns_enabled = true;
      };
    })

  ];
}
