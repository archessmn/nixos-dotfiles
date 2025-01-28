{ lib, config, pkgs, unstablePkgs, username, ... }:
with lib;
let
  cfg = config.archessmn.roles.consul.server;
in
{
  options.archessmn.roles.consul.server = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.consul = {
      enable = true;

      webUi = true;
      interface = {
        bind = "tailscale0";
      };

      extraConfig = {
        server = true;

        addresses = {
          http = "0.0.0.0";
          dns = "127.0.0.1";
        };

        bootstrap_expect = 3;

        advertise_addr = "{{ GetInterfaceIP \"tailscale0\" }}";

      };
    };
  };
}
