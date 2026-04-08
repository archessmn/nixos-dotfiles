{
  lib,
  ...
}:
with lib;
{
  imports = [
    ../desktop
    ../home
    ../roles/_default.nix
    ../system
  ];

  config = {
    archessmn.home.enable = mkDefault true;
    archessmn.system.enable = mkDefault true;
  };
}
