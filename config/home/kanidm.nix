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
  home.file.".config/kanidm".source = ../../modules/archessmn/home/home-manager/files/kanidm;
}
