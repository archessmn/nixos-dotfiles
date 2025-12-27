{
  lib,
  config,
  username,
  ...
}:
with lib;
let
  shellEnabled = config.archessmn.home.home-manager.shell.enable;
  cfg = config.archessmn.home.home-manager.shell.eza;
in

{
  options.archessmn.home.home-manager.shell.eza = {
    enable = mkOption {
      type = types.bool;
      default = shellEnabled;
    };
  };

  config.home-manager.users.${username} = mkIf cfg.enable {
    programs.eza = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
      icons = "auto";
    };

  };
}
