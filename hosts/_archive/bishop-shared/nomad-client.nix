{ config, lib, pkgs, ... }:

{
  services.nomad = {
    enable = true;
    dropPrivileges = false;
    settings = {
      client = {
        enabled = true;
        servers = [
          "nixos-103-bishop:4647"
          "nixos-104-bishop:4647"
          "nixos-105-bishop:4647"
        ];
      };
    };
  };
}
