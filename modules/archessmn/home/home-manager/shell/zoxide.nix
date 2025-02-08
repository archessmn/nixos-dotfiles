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
  cfg = config.archessmn.home.home-manager.shell.zoxide;
in

{
  options.archessmn.home.home-manager.shell.zoxide = {
    enable = mkOption {
      type = types.bool;
      default = shellEnabled;
    };
  };

  config.home-manager.users.${username} = mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };
  };
}
