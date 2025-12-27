{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.nomad.client;
in
{
  options.archessmn.roles.nomad.client = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.nomad = {
      settings = {
        client = {
          enabled = true;
          servers = [
            "localhost"
            "av-imposter.wahoo-monster.ts.net:4647"
            "tsuro.wahoo-monster.ts.net:4647"
          ];
          network_interface = "tailscale0";
        };
      };
    };
  };
}
