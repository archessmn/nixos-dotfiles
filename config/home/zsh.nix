{ config, pkgs, inputs, username,
  gitUsername, gitEmail,
  browser, flakeDir, ... }:

{
  imports = [
    ./shell/eza.nix
    ./shell/fzf.nix
    ./shell/zoxide.nix
  ];
  
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    shellAliases = {
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
}
