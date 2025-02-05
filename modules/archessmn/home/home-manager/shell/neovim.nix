{ lib, config, pkgs, unstablePkgs, username, ... }:
with lib;
let
  shellEnabled = config.archessmn.home.home-manager.shell.enable;
  cfg = config.archessmn.home.home-manager.shell.neovim;
in

{
  options.archessmn.home.home-manager.shell.neovim = {
    enable = mkOption {
      type = types.bool;
      default = shellEnabled;
    };
  };

  config.home-manager.users.${username} = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
    };

    home.file.".config/nvim".source = ../files/nvim;
    home.file.".config/nvim".recursive = true;
  };
}
