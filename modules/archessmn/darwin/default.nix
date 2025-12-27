{
  lib,
  ...
}:
with lib;
{
  imports = [
    ../desktop
    ../home
    ../system
  ];

  config = {
    archessmn.home.enable = mkDefault true;
    archessmn.desktop.enable = mkDefault false;
  };
}
