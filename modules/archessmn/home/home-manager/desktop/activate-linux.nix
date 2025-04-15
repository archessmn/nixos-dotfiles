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
  cfg = config.archessmn.home.home-manager.desktop.activate-linux;
in

{
  imports = [ ];

  options.archessmn.home.home-manager.desktop.activate-linux = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
      home.packages = [
        pkgs.gnomeExtensions.activate_gnome
      ];

      dconf.settings."org/gnome/shell/extensions/activate_gnome" = {
        size-l1 = 26.0;
        size-l2 = 16.0;
        text-l1 = "Activate NixOS";
        text-l2 = "Go to Settings to activate NixOS.";
      };
    };
  };
}
