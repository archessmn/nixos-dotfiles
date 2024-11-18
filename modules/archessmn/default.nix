{ lib, config, pkgs, unstablePkgs, username, fsh, flakeDir, ... }:
with lib;
let
  cfg = config.archessmn;
in
{
  imports = [
    ./desktop
    ./home
    ./system
  ];

  config = {
    archessmn.home.enable = mkDefault true;
    archessmn.system.enable = mkDefault true;
  };
}
