{
  config,
  pkgs,
  inputs,
  username,
  gitUsername,
  gitEmail,
  browser,
  flakeDir,
  ...
}:

{
  programs.kitty = {
    enable = true;
    font.package = pkgs.nerd-fonts.fira-mono;
    font.name = "FiraMono Nerd Font";
    extraConfig = "linux_display_server X11";

    shellIntegration = {
      enableZshIntegration = true;
    };
  };
}
