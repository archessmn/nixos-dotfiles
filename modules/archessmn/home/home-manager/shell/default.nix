{ lib, config, pkgs, unstablePkgs, username, ... }:
with lib;
let
  cfg = config.archessmn.home.home-manager.shell;
in

{
  imports = [
    ./atuin.nix
    ./eza.nix
    ./fzf.nix
    ./neovim.nix
    ./thefuck.nix
    ./yazi.nix
    ./zoxide.nix
  ];

  options.archessmn.home.home-manager.shell = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config.home-manager.users.${username} = mkIf cfg.enable {
    programs.fish = {
      enable = true;

      shellAliases = {
        y = "yazi";
        # cd = "z";
        # cdi = "zi";
        cat = "bat";
        bonk = "clear";
        nixconfig = "cd ~/nixos-dotfiles/";
        rebuild = "cd ~/nixos-dotfiles/ && ./deploy";
      };
    };

    programs.fsh.enable = mkDefault true;

    programs.thefuck = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };

    programs.navi = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };

    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    home.packages = [
      # Terminal shit
      pkgs.git
      pkgs.gh
      pkgs.vimPlugins.nvim-treesitter
      pkgs.vimPlugins.nvim-treesitter-parsers.nix
      pkgs.walk
      pkgs.bat
      pkgs.neofetch
      pkgs.htop
      pkgs.btop
      pkgs.sl

      # Programming things
      pkgs.rustc
      pkgs.cargo
      pkgs.nodejs
      pkgs.nodePackages.npm
      pkgs.yarn
      pkgs.bun
      pkgs.gccgo13
      pkgs.jdk21
    ];
  };
}