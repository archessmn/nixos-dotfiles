{ config, lib, pkgs, ... }:

{
  imports = [
    ./consul/shared.nix
  ];

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

      retry_join = [
        "nixos-103-bishop"
        "nixos-104-bishop"
        "nixos-105-bishop"
        "nixos-200-bishop"
      ];

      bootstrap_expect = 3;

      advertise_addr = "{{ GetInterfaceIP \"tailscale0\" }}";

    };
  };
}
