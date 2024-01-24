{ config, pkgs, inputs, username,
  gitUsername, gitEmail,
  browser, flakeDir, ... }:

{
  programs.kitty = {
    enable = true;
    font.package = (pkgs.nerdfonts.override { fonts = [ "FiraMono" ]; });
    font.name = "FiraMono Nerd Font";
    extraConfig = "background_opacity 0.9\nbackground_blur 64";
  };
}
