{
  lib,
  config,
  pkgs,
  username,
  isDarwin,
  ...
}:
with lib;
let
  keys = import ../../../config/ssh/keys.nix;
  cfg = config.archessmn.home;
  users = import ../../../users.nix;
in

{
  imports = [
    ./home-manager
  ];

  options.archessmn.home = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    programs.fish.enable = true;

    users.users.${username} = mkMerge [
      {
        shell = pkgs.fish;
        ignoreShellProgramCheck = true;
        openssh.authorizedKeys.keys = (map (key: getAttr key keys) (attrNames keys));
      }
      (mkIf (!isDarwin) {
        isNormalUser = true;
        description = users.${username}.fullName;
        extraGroups = [
          "networkmanager"
          "wheel"
          "dialout"
          "wireshark"
        ];
        hashedPassword = "$y$j9T$B5ed95B4bkDU59CaypqDn0$ej48gzEYheqfaoZ3l4Iu07/kdAC8dJqBEBHZKTmuPyC";
      })
      (mkIf isDarwin {
        home = "/Users/${username}";
      })
    ];
  };
}
