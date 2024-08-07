{ lib, config, pkgs, unstablePkgs, theLocale, theTimezone, username, ... }:
with lib;
let
  cfg = config.desktop.testing;
in
{
  options.desktop.testing = {
    docker = mkOption {
      type = types.bool;
      default = false;
    };

    virtualBox = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkMerge [
    (mkIf cfg.docker {
      virtualisation.docker.enable = true;

      users.users."${username}".extraGroups = [ "docker" ];
    })
    (mkIf cfg.virtualBox {
      virtualisation.virtualbox.host.enable = true;
      users.extraGroups.vboxusers.members = [ "${username}" ];
    })
  ];
}
