{
  lib,
  config,
  pkgs,
  username,
  hostname,
  isDarwin,
  ...
}:
with lib;
let
  cfg = config.archessmn.home.home-manager.desktop.git;
in

{
  options.archessmn.home.home-manager.desktop.senpai = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    age.secrets.senpai_password = {
      file = ../../../../../secrets/${hostname}/senpai_password.age;
      mode = "600";
      owner = "${username}";
    };

    home-manager.users.${username} = {
      programs.senpai = {
        enable = true;
        config = {
          address = "ircs://tsuro.infra.archess.mn";
          nickname = "archessmn";
          password-cmd = [
            "${pkgs.coreutils}/bin/cat"
            config.age.secrets.senpai_password.path
          ];
        };
      };

      xdg.configFile."senpai/senpai.scfg" = mkIf isDarwin {
        target = "../Library/Application Support/senpai/senpai.scfg";
      };
    };
  };
}
