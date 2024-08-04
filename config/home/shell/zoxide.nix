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
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };
}
