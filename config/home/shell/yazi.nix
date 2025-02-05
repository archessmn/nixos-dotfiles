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
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };
}
