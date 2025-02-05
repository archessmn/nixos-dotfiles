{ lib, config, pkgs, unstablePkgs, username, ... }:
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
        pkgs.activate-linux
      ];

      systemd.user.services.activate-linux = {
        Unit = {
          Description = "Systemd service for activate-linux";
          Requires = [ "graphical-session.target" ];
        };
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.activate-linux}/bin/activate-linux";
        };
        Install.WantedBy = [ "gnome-session.target" ];
      };
    };
  };
}
