{ lib, config, pkgs, inputs, username,
  gitUsername, gitEmail,
  browser, flakeDir, ... }:

with lib.hm.gvariant;
{
  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    settings."org/gnome/shell/extensions/blur-my-shell" = {
      brightness = 0.64;
      color = (mkTuple [0.356 0.054 0.397 0.233]);
      hacks-level = 3;
      noise-amount = 0.2;
      noise-lightness = 0.69;
      sigma = 45;
    };
    settings."org/gnome/shell/extensions/blur-my-shell/applications" = {
      blacklist = ["Plank"];
      blur-on-overview = false;
      brightness = 0.8;
      enable-all = false;
      opacity = 230;
      sigma = 6;
      whitelist = ["kitty"];
    };
    settings."org/gnome/shell/extensions/blur-my-shell/overview" = {
      blur = true;
      style-components = 3;
    };
    settings."org/gnome/shell/extensions/blur-my-shell/panel" = {
      override-background = true;
    }; 
  };
}
