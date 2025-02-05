{ lib, config, pkgs, unstablePkgs, username, ... }:
with lib;
let
  cfg = config.archessmn.roles.consul.client;
in
{
  options.archessmn.roles.consul.client = {
    enable = mkOption {
      type = types.bool;
      default = config.archessmn.roles.consul.server.enable;
    };
  };

  config = mkIf cfg.enable {
    services.consul = {
      enable = true;

      interface = {
        bind = "tailscale0";
      };

      extraConfig = {

        addresses = {
          http = "0.0.0.0";
          dns = "127.0.0.1";
        };

        retry_join = [
          "localhost"
          "av-imposter.wahoo-monster.ts.net"
          "temjin.wahoo-monster.ts.net"
          "tsuro.wahoo-monster.ts.net"
        ];

        advertise_addr = "{{ GetInterfaceIP \"tailscale0\" }}";

      };
    };
  };
}
