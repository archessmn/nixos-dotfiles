{
  lib,
  config,
  pkgs,
  unstable-pkgs,
  username,
  ...
}:
with lib;
let
  shellEnabled = config.archessmn.home.home-manager.shell.enable;
  cfg = config.archessmn.home.home-manager.shell.thefuck;
in

{
  options.archessmn.home.home-manager.shell.thefuck = {
    enable = mkOption {
      type = types.bool;
      default = shellEnabled;
    };
  };

  config.home-manager.users.${username} = mkIf cfg.enable {
    programs.thefuck = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };
  };
}
