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
  cfg = config.archessmn.home.home-manager.desktop.terminals.kitty;
in

{
  imports = [ ];

  options.archessmn.home.home-manager.desktop.terminals.kitty = {
    enable = mkOption {
      type = types.bool;
      default = desktopEnabled;
    };
  };

  config.home-manager.users.${username} = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      font.package = pkgs.nerd-fonts.fira-mono;
      font.name = "FiraMono Nerd Font Mono";
      extraConfig = "linux_display_server X11";

      shellIntegration = {
        enableZshIntegration = true;
        enableFishIntegration = true;
      };
    };
  };
}
