{
  lib,
  config,
  pkgs,
  username,
  ...
}:
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

    firewall.json-server.open = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} = {
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

    networking.firewall.allowedTCPPorts = mkIf cfg.firewall.json-server.open [ 19444 ];
  };
}
