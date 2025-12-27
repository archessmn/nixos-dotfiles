{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.jellyfin;
in
{
  options.archessmn.roles.jellyfin = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.jellyfin = {
      enable = true;
    };
  };
}
