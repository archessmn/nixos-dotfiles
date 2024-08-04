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
  programs.rio = {
    enable = true;
  };
}
