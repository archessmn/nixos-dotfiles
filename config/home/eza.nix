{ config, pkgs, inputs, username,
  gitUsername, gitEmail,
  browser, flakeDir, ... }:

{
  programs.eza = {
    enable = true;
    enableAliases = true;
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
    icons = true;
  };
}
