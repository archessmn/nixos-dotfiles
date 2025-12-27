{
  lib,
  config,
  unstable-pkgs,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.nomad;
in
{

  imports = [
    ./client.nix
    ./server.nix
  ];

  options.archessmn.roles.nomad = { };

  config = mkIf (cfg.server.enable || cfg.client.enable) {
    systemd.tmpfiles.rules = [
      "d /opt/nomad 1600 root nomad"
    ];

    services.nomad = {
      package = unstable-pkgs.nomad;
      enable = true;
      enableDocker = true;
      dropPrivileges = false;
      settings = {
        advertise = {
          http = "{{ GetInterfaceIP \"tailscale0\" }}";
          rpc = "{{ GetInterfaceIP \"tailscale0\" }}";
          serf = "{{ GetInterfaceIP \"tailscale0\" }}";
        };

        vault = {
          enabled = true;
          address = "http://active.vault.service.consul:8200";
        };
      };
    };
  };
}
