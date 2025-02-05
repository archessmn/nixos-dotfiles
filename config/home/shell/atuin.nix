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
  programs.atuin = {
    enable = true;
    settings = {
      auto_sync = true;
      sync_frequency = "1m";
      sync_address = "https://atuin.archess.mn";
    };
    enableZshIntegration = true;
    enableFishIntegration = true;
  };
}
