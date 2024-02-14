{ config, pkgs, inputs, username,
  gitUsername, gitEmail,
  browser, flakeDir, ... }:

{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
