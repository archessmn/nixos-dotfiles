{ lib, config, pkgs, unstablePkgs, username, ... }:
with lib;
let
  cfg = config.archessmn.roles;
in
{

  imports = [
    ./consul
    ./traefik.nix
    ./uptime-kuma.nix
    ./vaultwarden.nix
  ];

  options.archessmn.roles = { };

  config = { };
}
