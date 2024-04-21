{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../bishop-shared/default.nix
      ../bishop-shared/nomad-server.nix
      ../bishop-shared/consul.nix
    ];

  networking.hostName = "nixos-103-bishop"; # Define your hostname.

  services.consul = {
    enable = true;
    webUi = true;
    interface.advertise = "tailscale0";
    interface.bind = "tailscale0";
    extraConfig = {
      client_addr = "{{ GetPrivateInterfaces | exclude \"type\" \"ipv6\" | join \"address\" \" \" }}";
    };
  };


  system.stateVersion = "23.11";
}
