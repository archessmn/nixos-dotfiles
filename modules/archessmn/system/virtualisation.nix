{
  lib,
  config,
  pkgs,
  username,
  ...
}:
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
      virtualisation.docker = {
        enable = true;

        daemon.settings = {
          bip = "172.31.0.1/16";

          default-address-pools = [
            {
              base = "172.31.0.0/16";
              size = 16;
            }
          ];

          dns = [ "172.31.0.1" ];
        };
      };

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
