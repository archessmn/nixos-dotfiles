{
  lib,
  config,
  pkgs,
  unstable-pkgs,
  username,
  isDarwin,
  ...
}:
with lib;
let
  cfg = config.archessmn.home.home-manager.shell;
in

{
  imports = [
    ./atuin.nix
    ./eza.nix
    ./fzf.nix
    ./helix.nix
    ./pay-respects.nix
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

      functions = {
        fish_greeting = "";
      };

      shellAliases = {
        y = "yazi";
        # cd = "z";
        # cdi = "zi";
        cat = "bat";
        bonk = "clear";
        nixconfig = "cd ~/nixos-dotfiles/";
        rebuild = "cd ~/nixos-dotfiles/ && ./deploy";
        please = "sudo";
      };

      interactiveShellInit = "
        function \"gogogadget\"
          nix run nixpkgs#$argv
        end

        function \"go go gadget\"
          nix run nixpkgs#$argv
        end
      ";
    };

    programs.fsh.enable = mkDefault true;

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
      pkgs.walk
      pkgs.bat
      pkgs.neofetch
      pkgs.htop
      pkgs.btop
      pkgs.sl
      pkgs.dig
      pkgs.lsof
      pkgs.minicom

      # Programming things
      unstable-pkgs.rustc
      unstable-pkgs.cargo
      unstable-pkgs.rustlings
      # pkgs.gccgo13
      pkgs.jdk21
    ]
    ++ optionals (!isDarwin) [
      pkgs.dysk
    ];
  };
}
