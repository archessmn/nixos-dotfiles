{
  lib,
  config,
  pkgs,
  unstable-pkgs,
  username,
  fsh,
  ...
}:
with lib;
let
  keys = import ../../../config/ssh/keys.nix;
  cfg = config.archessmn.home;
  users = import ../../../users.nix;
in

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
