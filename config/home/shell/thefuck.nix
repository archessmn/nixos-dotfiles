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
  programs.thefuck = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };
}
