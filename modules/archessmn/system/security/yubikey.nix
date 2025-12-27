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
    yubikeyForSudo = mkOption {
      type = types.bool;
      default = config.archessmn.desktop.enable;
    };
  };

  config = mkIf cfg.system.security.yubikeyForSudo {
    security.pam.services = {
      sudo.u2fAuth = true;
    };
  };
}
