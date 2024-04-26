{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../bishop-shared/default.nix
      ../bishop-shared/nomad-client.nix
      ../bishop-shared/consul-client.nix
      ../bishop-shared/vault.nix
      ../bishop-shared/vault-agent.nix
    ];

  networking.hostName = "nixos-200-bishop"; # Define your hostname.

  system.stateVersion = "23.11";
}
