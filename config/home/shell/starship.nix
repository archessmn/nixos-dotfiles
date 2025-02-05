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
  programs.starship = {
    enable = false;
    settings = {
      directory = {
        truncation_length = 2;
        fish_style_pwd_dir_length = 1;
      };

      hostname = {
        format = "[$hostname]($style) in ";
      };
    };
  };
}
