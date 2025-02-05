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
  programs.kitty = {
    enable = true;
    font.package = (pkgs.nerdfonts.override { fonts = [ "FiraMono" ]; });
    font.name = "FiraMono Nerd Font";
    extraConfig = "linux_display_server X11";

    shellIntegration = {
      enableZshIntegration = true;
    };
  };
}
