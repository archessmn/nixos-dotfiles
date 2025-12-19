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
  cfg = config.archessmn.home.home-manager.shell.atuin;
in

{
  options.archessmn.home.home-manager.shell.atuin = {
    enable = mkOption {
      type = types.bool;
      default = shellEnabled;
    };
  };

  config.home-manager.users.${username} = mkIf cfg.enable {
    programs.atuin = {
      enable = true;
      settings = {
        auto_sync = true;
        sync_frequency = "1m";
        sync_address = "https://atuin.archess.mn";
        ctrl_n_shortcuts = true;
        style = "auto";
      };
      enableZshIntegration = true;
      enableFishIntegration = true;
    };
  };
}
