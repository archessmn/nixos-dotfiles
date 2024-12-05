{ lib, config, pkgs, unstablePkgs, username, ... }:
with lib;
let
  cfg = config.archessmn.roles.consul.client;
in
{
  options.archessmn.roles.consul.client = {
    enable = mkOption {
      type = types.bool;
      default = false;
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
        };

        retry_join = [
          "localhost"
        ];

        advertise_addr = "{{ GetInterfaceIP \"tailscale0\" }}";

      };
    };
  };
}
