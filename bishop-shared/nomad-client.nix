{ config, lib, pkgs, ... }:

{
  networking.firewall.allowedTCPPortRanges = [{ from = 20000; to = 32000; }];
  services.nomad = {
    enable = true;
    dropPrivileges = false;
    settings = {
      client = {
        enabled = true;
        servers = [
          "nixos-103-bishop:4647"
          "nixos-104-bishop:4647"
          "nixos-105-bishop:4647"
        ];
        network_interface = "tailscale0";
      };
      bind_addr = "{{ GetInterfaceIP \"tailscale0\" }}";
      advertise = {
        http = "{{ GetInterfaceIP \"tailscale0\" }}";
        rpc = "{{ GetInterfaceIP \"tailscale0\" }}";
        serf = "{{ GetInterfaceIP \"tailscale0\" }}";
      };
    };
  };
}
