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
  desktopEnabled = config.archessmn.desktop.enable;
  cfg = config.archessmn.home.home-manager.desktop.terminals.ghostty;
in

{
  imports = [ ];

  options.archessmn.home.home-manager.desktop.terminals.ghostty = {
    enable = mkOption {
      type = types.bool;
      default = desktopEnabled;
    };
  };

  config.home-manager.users.${username} = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      settings = {
        font-family = "FiraMono Nerd Font";
        window-inherit-working-directory = false;
      };
      enableZshIntegration = true;
      enableFishIntegration = true;
    };
  };
}
