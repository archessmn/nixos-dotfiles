{ config, pkgs, inputs, username,
  gitUsername, gitEmail,
  browser, flakeDir, ... }:

{
  imports = [
    ./shell/eza.nix
    ./shell/fzf.nix
    ./shell/thefuck.nix
    ./shell/zoxide.nix
  ];
 
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    shellAliases = {
      cd = "z";
      cdi = "zi";
      cat = "bat";
      bonk = "clear";
      nixconfig = "cd ~/nixos-dotfiles/";
      rebuild = "cd ~/nixos-dotfiles/ && ./deploy";
    };
    enableVteIntegration = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "genpass"
            ];
      theme = "robbyrussell";
    };
  };

  programs.thefuck = {
    enable = true;
    enableZshIntegration = true;
  };
}
