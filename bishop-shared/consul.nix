{ config, lib, pkgs, ... }:

{
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
      };

      retry_join = [
        "nixos-103-bishop"
        "nixos-104-bishop"
        "nixos-105-bishop"
      ];

      bootstrap_expect = 3;

      advertise_addr = "{{ GetInterfaceIP \"tailscale0\" }}";

    };
  };
}
