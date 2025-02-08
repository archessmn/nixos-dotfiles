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
  cfg = config.archessmn.home.home-manager.desktop.gaming;
in

{
  imports = [ ];

  options.archessmn.home.home-manager.desktop.gaming = {
    enable = mkOption {
      type = types.bool;
      default = desktopEnabled;
    };
  };

  config.home-manager.users.${username} = mkIf cfg.enable {
    home.packages = [
      # Gaming stuff
      pkgs.lutris
      pkgs.steam
      pkgs.thunderbird
      pkgs.prismlauncher
    ];
  };
}
