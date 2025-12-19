{
  lib,
  config,
  pkgs,
  isDarwin,
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

  config = mkIf cfg.enable (mkMerge [
    {
      environment.variables.NH_FLAKE = "${flakeDir}";
    }
    (optionalAttrs (!isDarwin) {
      programs.nh = {
        enable = true;
        clean = {
          enable = true;
          extraArgs = "--keep-since 4d --keep 5";
        };
        flake = flakeDir;
      };
    })
    (optionalAttrs isDarwin {
      home-manager.users.${username}.home.packages = with pkgs; [ nh ];
    })
  ]);
}
