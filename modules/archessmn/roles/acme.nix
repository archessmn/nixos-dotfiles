{
  lib,
  config,
  hostname,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.acme;
in
{
  options.archessmn.roles.acme = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    age.secrets.cloudflare_dns_env.file = ../../../secrets/${hostname}/cloudflare_dns.env.age;

    security.acme = {
      acceptTerms = true;
      defaults = {
        email = "archessmn@gmail.com";
      };
      certs."${config.networking.hostname}.infra.archess.mn" = {
        dnsProvider = "cloudflare";
        environmentFile = config.age.secrets.cloudflare_dns_env.path;
      };
    };
  };
}
