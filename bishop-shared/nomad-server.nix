{ config, lib, pkgs, ... }:

{
  networking.firewall.allowedTCPPortRanges = [{ from = 20000; to = 32000; }];
  services.nomad = {
    enable = true;
    enableDocker = true;
    dropPrivileges = false;
    settings = {
      server = {
        enabled = true;
        bootstrap_expect = 3;
        # bootstrap_expect = 1;

        server_join = {
          retry_join = [
            "nixos-103-bishop:4648"
            "nixos-104-bishop:4648"
            "nixos-105-bishop:4648"
          ];
        };
      };
      client = {
        enabled = true;
        servers = [
          "localhost"
          "nixos-103-bishop:4647"
          "nixos-104-bishop:4647"
          "nixos-105-bishop:4647"
        ];
        network_interface = "tailscale0";
      };
      #bind_addr = "{{ GetInterfaceIP \"tailscale0\" }}";
      advertise = {
        http = "{{ GetInterfaceIP \"tailscale0\" }}";
        rpc = "{{ GetInterfaceIP \"tailscale0\" }}";
        serf = "{{ GetInterfaceIP \"tailscale0\" }}";
      };
    };
  };
}
