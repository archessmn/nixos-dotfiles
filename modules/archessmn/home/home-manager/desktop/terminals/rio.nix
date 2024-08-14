{ lib, config, pkgs, unstablePkgs, username, ... }:
with lib;
let
  desktopEnabled = config.archessmn.desktop.enable;
  cfg = config.archessmn.home.home-manager.desktop.terminals.rio;
in

{
  imports = [ ];

  options.archessmn.home.home-manager.desktop.terminals.rio = {
    enable = mkOption {
      type = types.bool;
      default = desktopEnabled;
    };
  };

  config.home-manager.users.${username} = mkIf cfg.enable {
    programs.rio = {
      enable = true;
    };
  };
}
