{
  lib,
  config,
  # hostname,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.minecraft;
in
{
  options.archessmn.roles.minecraft = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      25565
    ];

    services.traefik = {
      staticConfigOptions = {
        entryPoints = {
          minecraft = {
            address = ":25565";
          };
        };
      };
    };
  };
}
