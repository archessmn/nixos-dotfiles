{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.consul;
in
{
  imports = [
    ./client.nix
    ./server.nix
  ];

  config = mkIf (cfg.client.enable || cfg.server.enable) {

  };
}
