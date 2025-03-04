{
  lib,
  config,
  pkgs,
  unstable-pkgs,
  username,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.nomad.server;
in
{
  options.archessmn.roles.nomad.server = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.nomad = {
      settings = {
        server = {
          enabled = true;
          # bootstrap_expect = 3;
          bootstrap_expect = 3;

          server_join = {
            retry_join = [
              "localhost:4648"
              "av-imposter.wahoo-monster.ts.net:4648"
            ];
          };
        };

        consul = {
          tags = [
            "traefik.http.routers.nomad.rule=Host(`nomad.tsuro.infra.archess.mn`)"
          ];
        };

        vault = {
          create_from_role = "nomad-server";
        };
      };
    };
  };
}
