{
  lib,
  config,
  username,
  ...
}:
with lib;
let
  desktopEnabled = config.archessmn.desktop.enable;
  cfg = config.archessmn.home.home-manager.desktop.git;
  keys = import ../../../../../config/ssh/keys.nix;
  user = (import ../../../../../users.nix).${username};

in

{
  options.archessmn.home.home-manager.desktop.git = {
    enable = mkOption {
      type = types.bool;
      default = desktopEnabled;
    };
  };

  config.home-manager.users.${username} = mkIf cfg.enable {
    home.file.".ssh/allowed_signers".text = concatMapStrings (key: "${user.email} ${key}\n") (
      map (key: getAttr key keys) (attrNames keys)
    );

    programs.git = {
      enable = true;

      settings = {
        user.email = user.email;
        user.name = user.fullName;
        init.defaultBranch = "main";
        push.autoSetupRemote = "true";
        pull.rebase = true;
        commit.gpgsign = true;
        gpg.format = "ssh";
        gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
        user.signingkey = "~/.ssh/id_ed25519";
      };
    };

  };
}
