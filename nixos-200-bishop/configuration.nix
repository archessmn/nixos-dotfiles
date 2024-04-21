{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../bishop-shared/default.nix
      ../bishop-shared/nomad-client.nix
      ../bishop-shared/consul-client.nix
    ];

  networking.hostName = "nixos-200-bishop"; # Define your hostname.

  services.vault = {
    enable = true;
    package = pkgs.vault-bin;
    address = "0.0.0.0:8200";
    extraConfig = ''
      ui = true
      disable_mlock = true
    '';
    #listenerExtraConfig = ''
    #  tls_disable = true
    #'';
  };

  system.stateVersion = "23.11";
}
