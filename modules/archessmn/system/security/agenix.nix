{
  lib,
  config,
  system,
  agenix,
  ...
}:
with lib;
let
  cfg = config.archessmn.system.security.agenix;
in
{
  options.archessmn.system.security.agenix = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ agenix.packages.${system}.default ];
  };
}
