{
  lib,
  config,
  pkgs,
  unstable-pkgs,
  username,
  fsh,
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
  };

  config.home-manager = mkIf cfg.enable {
    # extraSpecialArgs = {
    #   inherit pkgs;
    #   inherit username;
    #   inherit unstable-pkgs;
    #   inherit fsh;
    # };
    useGlobalPkgs = true;
    useUserPackages = true;

    users.${username} = {
      home.username = "${username}";
      home.homeDirectory = "/home/${username}";
      home.stateVersion = "23.11";

      imports = [
        fsh.homeModules.fsh
      ];
    };
  };
}
