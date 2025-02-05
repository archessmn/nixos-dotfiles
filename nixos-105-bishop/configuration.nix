{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../bishop-shared/default.nix
      ../bishop-shared/nomad-server.nix
      ../bishop-shared/consul.nix
    ];

  networking.hostName = "nixos-105-bishop"; # Define your hostname.

  system.stateVersion = "23.11";
}
