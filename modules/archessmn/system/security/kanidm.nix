{
  lib,
  config,
  pkgs,
  unstable-pkgs,
  ...
}:
with lib;
let
  cfg = config.archessmn.system.security.kanidm;
in
{
  options.archessmn.system.security.kanidm = {
    client.enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.client.enable {
    services.kanidm = {
      package = pkgs.kanidm_1_10;

      client = {
        enable = true;

        settings = {
          uri = "https://idm.archess.mn";
          verify_ca = true;
          verify_hostnames = true;
        };
      };

    };
  };
}
