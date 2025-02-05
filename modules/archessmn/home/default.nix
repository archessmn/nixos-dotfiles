{ lib, config, pkgs, unstablePkgs, username, fsh, ... }:
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

    cmatrix = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    programs.fish.enable = true;

    users.users.${username} = {
      isNormalUser = true;
      description = users.${username}.fullName;
      extraGroups = [ "networkmanager" "wheel" "dialout" "wireshark" ];
      hashedPassword = "$y$j9T$B5ed95B4bkDU59CaypqDn0$ej48gzEYheqfaoZ3l4Iu07/kdAC8dJqBEBHZKTmuPyC";
      ignoreShellProgramCheck = true;
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = (map (key: getAttr key keys) (attrNames keys));
    };
  };
}
