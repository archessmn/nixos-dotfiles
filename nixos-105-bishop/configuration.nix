{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../bishop-shared/default.nix
      ../bishop-shared/nomad-server.nix
    ];

  networking.hostName = "nixos-105-bishop"; # Define your hostname.

  system.stateVersion = "23.11";
}
