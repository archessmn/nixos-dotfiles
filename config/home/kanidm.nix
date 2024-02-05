{ config, pkgs, inputs, username,
  gitUsername, gitEmail,
  browser, flakeDir, ... }:

{
  home.file.".config/kanidm".source = ../kanidm;
}
