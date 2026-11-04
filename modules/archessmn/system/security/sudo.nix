{
  lib,
  config,
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
      default = true;
    };
  };

  config = mkIf cfg.system.security.sudoNoPasswd {
    security.sudo.wheelNeedsPassword = false;
  };
}
