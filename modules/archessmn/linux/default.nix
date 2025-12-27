{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.archessmn;
in
{
  imports = [
    ../desktop
    ../home
    ../roles
    ../system
  ];

  config = {
    archessmn.home.enable = mkDefault true;
    archessmn.system.enable = mkDefault true;
  };
}
