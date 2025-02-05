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
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
    icons = "auto";
  };
}
