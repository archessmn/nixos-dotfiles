{ lib, config, pkgs, unstablePkgs, username, ... }:
with lib;
let
  shellEnabled = config.archessmn.home.home-manager.shell.enable;
  cfg = config.archessmn.home.home-manager.shell.fzf;
in

{
  options.archessmn.home.home-manager.shell.fzf = {
    enable = mkOption {
      type = types.bool;
      default = shellEnabled;
    };
  };

  config.home-manager.users.${username} = mkIf cfg.enable {
    programs.fzf = {
      enable = false;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };
  };
}
