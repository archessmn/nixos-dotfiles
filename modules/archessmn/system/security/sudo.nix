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
  cfg = config.archessmn;
in
{
  options.archessmn.system.security = {
    sudoNoPasswd = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.system.security.sudoNoPasswd {
    security.sudo.extraRules = [
      {
        users = [ "${username}" ];
        runAs = "ALL:ALL";
        commands = [
          {
            command = "ALL";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];

  };
}
