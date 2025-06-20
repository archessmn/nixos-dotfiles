{
  lib,
  config,
  pkgs,
  unstable-pkgs,
  fsh,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.family-pc;
  username = "hous";
  users = import ../../../users.nix;
in
{
  options.archessmn.roles.family-pc = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    programs.fish.enable = true;

    users.users.hous = {
      isNormalUser = true;
      description = users.${username}.fullName;
      extraGroups = [ ];
      hashedPassword = "$6$9jX14kERlzPLo1R7$jFEiJCWcxlgO6RKr8ec34LuHhVbFOWtkm89j7B0ZzIIET5QQGINeprJn2UknMgtKaEBujKOa/2JFIK5G/Is.00";
      ignoreShellProgramCheck = true;
      shell = pkgs.fish;
    };

    home-manager = {
      users.${username} = {
        home.username = "${username}";
        home.homeDirectory = "/home/${username}";
        home.stateVersion = "24.05";

        imports = [
          fsh.homeModules.fsh
        ];

        fonts.fontconfig.enable = true;

        home.packages = [
          pkgs.nerd-fonts.fira-mono
        ];

        programs.fish = {
          enable = true;
        };
        programs.fsh.enable = mkDefault true;
      };
    };
  };
}
