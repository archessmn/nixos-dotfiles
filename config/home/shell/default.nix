{ config
, pkgs
, inputs
, username
, gitUsername
, gitEmail
, browser
, flakeDir
, ...
}:

{
  imports = [
    ./atuin.nix
    ./eza.nix
    ./fzf.nix
    # ./shell/starship.nix
    ./thefuck.nix
    ./yazi.nix
    ./zoxide.nix
  ];

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
  programs.fsh.enable = true;

  # programs.zsh = {
  #   enable = true;
  #   dotDir = ".config/zsh";
  #   shellAliases = {
  #     cd = "z";
  #     cdi = "zi";
  #     cat = "bat";
  #     bonk = "clear";
  #     nixconfig = "cd ~/nixos-dotfiles/";
  #     rebuild = "cd ~/nixos-dotfiles/ && ./deploy";
  #   };
  #   enableVteIntegration = true;

  #   defaultKeymap = "emacs";

  #   initExtra = ''
  #     bindkey "^[[1;5C" forward-word 
  #     bindkey "^[[1;5D" backward-word
  #     bindkey "^[[H"    beginning-of-line
  #     bindkey "^[[F"    end-of-line
  #   '';
  # };

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
}
