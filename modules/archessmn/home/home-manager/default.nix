{
  lib,
  config,
  username,
  fsh,
  isDarwin,
  ...
}:
with lib;
let
  keys = import ../../../config/ssh/keys.nix;
  cfg = config.archessmn.home.home-manager;
  users = import ../../../users.nix;
in

{
  imports = [
    ./desktop
    ./shell
  ];

  options.archessmn.home.home-manager = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };

    stateVersion = mkOption {
      type = types.str;
      default = "23.11";
    };
  };

  config.home-manager = mkIf cfg.enable {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.${username} = mkMerge [
      {
        home.username = "${username}";
        home.stateVersion = cfg.stateVersion;

        imports = [
          fsh.homeModules.fsh
        ];
      }
      (mkIf (!isDarwin) {
        home.homeDirectory = "/home/${username}";
      })
    ];
  };
}
