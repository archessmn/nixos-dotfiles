{ lib, config, pkgs, unstablePkgs, username, ... }:
with lib;
let
  shellEnabled = config.archessmn.home.home-manager.shell.enable;
  cfg = config.archessmn.home.home-manager.shell.yazi;
in

{
  options.archessmn.home.home-manager.shell.yazi = {
    enable = mkOption {
      type = types.bool;
      default = shellEnabled;
    };
  };

  config.home-manager.users.${username} = mkIf cfg.enable {
    programs.yazi = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };
  };
}
