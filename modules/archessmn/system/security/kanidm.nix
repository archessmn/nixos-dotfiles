{ lib, config, pkgs, unstablePkgs, username, ... }:
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
      package = unstablePkgs.kanidm;

      enableClient = true;

      clientSettings = {
        uri = "https://idm.archess.mn";
        verify_ca = true;
        verify_hostnames = true;
      };
    };
  };
}
