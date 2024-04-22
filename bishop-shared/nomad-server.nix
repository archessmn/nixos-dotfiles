{ config, lib, pkgs, ... }:

{
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
