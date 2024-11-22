{ lib, config, pkgs, unstablePkgs, username, ... }:
with lib;
let
  cfg = config.archessmn.roles;
in
{

  imports = [
    ./traefik.nix
  ];

  options.archessmn.roles = { };

  config = { };
}
