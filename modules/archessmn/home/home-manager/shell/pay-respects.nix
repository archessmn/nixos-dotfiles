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
  cfg = config.archessmn.home.home-manager.shell.pay-respects;
in

{
  options.archessmn.home.home-manager.shell.pay-respects = {
    enable = mkOption {
      type = types.bool;
      default = shellEnabled;
    };
  };

  config.home-manager.users.${username} = mkIf cfg.enable {
    programs.pay-respects = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };
  };
}
