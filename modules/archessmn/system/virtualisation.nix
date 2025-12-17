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
      networking.firewall.trustedInterfaces = [ "docker0" ];

      virtualisation.docker = {
        enable = true;

        daemon.settings = {
          bip = "172.30.0.1/15";

          default-address-pools = [
            {
              base = "172.30.0.0/15";
              size = 29;
            }
          ];

          dns = [ "172.30.0.1" ];
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
