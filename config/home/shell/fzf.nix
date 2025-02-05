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
  programs.fzf = {
    enable = false;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };
}
