{ lib, config, pkgs, unstablePkgs, username, ... }:
with lib;
let
  cfg = config.archessmn.roles.consul;
in
{
  imports = [
    ./client.nix
    ./server.nix
  ];

  config = mkIf (cfg.client.enable || cfg.server.enable) {
    services.resolved = {
      extraConfig = ''
        [Resolve]
        DNS=127.0.0.1
        DNSSEC=false
        Domains=~consul
      '';
    };

    networking.firewall.extraCommands = ''
      iptables --table nat --append OUTPUT --destination localhost --protocol udp --match udp --dport 53 --jump REDIRECT --to-ports 8600
      iptables --table nat --append OUTPUT --destination localhost --protocol tcp --match tcp --dport 53 --jump REDIRECT --to-ports 8600
    '';
  };
}
