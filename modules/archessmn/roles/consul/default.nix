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
        DNS=127.0.0.1:8600
        DNSSEC=false
        Domains=~consul

        [Resolve]
        DNSStubListener=yes
        DNSStubListenerExtra=172.30.0.1
      '';
    };
  };
}
