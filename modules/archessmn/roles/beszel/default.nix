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
    ./agent.nix
    ./hub.nix
  ];

  config = mkIf (cfg.hub.enable) {

  };
}
