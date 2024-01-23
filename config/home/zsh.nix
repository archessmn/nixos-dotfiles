{ config, pkgs, inputs, username,
  gitUsername, gitEmail,
  browser, flakeDir, ... }:

{
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    shellAliases = {
      cat = "bat";
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
