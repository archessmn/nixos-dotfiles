{ lib, config, pkgs, unstablePkgs, username, ... }:
with lib;
let
  cfg = config.archessmn.home.home-manager.desktop.hyperion;
in

{
  imports = [ ];

  options.archessmn.home.home-manager.desktop.hyperion = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config.home-manager.users.${username} = mkIf cfg.enable {
    home.packages = [
      pkgs.hyperion-ng
    ];

    systemd.user.services.hyperion = {
      Unit = {
        Description = "Systemd service for hyperion";
        Requires = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.hyperion-ng}/bin/hyperiond --userdata /home/${username}/.hyperion";
      };
      Install.WantedBy = [ "gnome-session.target" ];
    };
  };
}
