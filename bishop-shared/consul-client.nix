{ config, lib, pkgs, ... }:

{
  services.consul = {
    enable = true;

    interface = {
      bind = "tailscale0";
    };

    extraConfig = {

      addresses = {
        http = "0.0.0.0";
      };

      retry_join = [
        "nixos-103-bishop"
        "nixos-104-bishop"
        "nixos-105-bishop"
      ];

      advertise_addr = "{{ GetInterfaceIP \"tailscale0\" }}";

    };
  };
}
