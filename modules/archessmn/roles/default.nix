{
  lib,
  config,
  pkgs,
  unstable-pkgs,
  username,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles;
in
{

  imports = [
    ./beszel
    ./consul
    ./nomad
    ./family-pc.nix
    ./frigate.nix
    ./immich.nix
    ./jellyfin.nix
    ./kanidm.nix
    ./keycloak.nix
    ./patroni.nix
    ./traefik.nix
    ./uptime-kuma.nix
    ./vaultwarden.nix
  ];

  options.archessmn.roles = { };

  config = { };
}
