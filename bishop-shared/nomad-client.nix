{ config, lib, pkgs, ... }:

{
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
