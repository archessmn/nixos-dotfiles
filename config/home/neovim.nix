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
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  home.file.".config/nvim".source = ../../modules/archessmn/home/home-manager/files/nvim;
  home.file.".config/nvim".recursive = true;
}
