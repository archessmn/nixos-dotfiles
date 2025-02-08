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
  cfg = config.archessmn.roles.beszel;
in
{
  imports = [
    ./hub.nix
  ];

  config = mkIf (cfg.hub.enable) {

  };
}
