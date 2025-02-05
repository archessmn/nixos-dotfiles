{ lib, config, pkgs, unstablePkgs, username, ... }:
with lib;
let
  shellEnabled = config.archessmn.home.home-manager.shell.enable;
  cfg = config.archessmn.home.home-manager.shell.helix;
in

{
  options.archessmn.home.home-manager.shell.helix = {
    enable = mkOption {
      type = types.bool;
      default = shellEnabled;
    };
  };

  config.home-manager.users.${username} = mkIf cfg.enable {
    programs.helix = {
      enable = true;
      defaultEditor = true;
    };
  };
}
