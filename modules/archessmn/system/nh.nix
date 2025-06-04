{
  lib,
  config,
  pkgs,
  unstable-pkgs,
  username,
  flakeDir,
  ...
}:
with lib;
let
  cfg = config.archessmn.system.nh;
in
{
  options.archessmn.system.nh = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    environment.variables.NH_FLAKE = "${flakeDir}";

    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 4d --keep 5";
      };
      flake = flakeDir;
    };
  };
}
