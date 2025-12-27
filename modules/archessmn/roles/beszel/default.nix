{
  lib,
  config,
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
