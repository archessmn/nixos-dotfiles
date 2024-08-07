{ lib, config, pkgs, unstablePkgs, theLocale, theTimezone, username, ... }:
with lib;
let
  cfg = config.archessmn.home;
in
{
  options.archessmn.home = {
    enable = mkEnableOption "Testing Modules";

    cmatrix = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${username}.home.packages = [
      pkgs.cmatrix
    ];
  };
}
