{ config, pkgs, inputs, username,
  gitUsername, gitEmail,
  browser, flakeDir, ... }:

{
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "23.11";

  imports = [
    ./config/home/dconf.nix
    ./config/home/eza.nix
    ./config/home/kitty.nix
    ./config/home/neovim.nix
    ./config/home/rio.nix
    ./config/home/vscode.nix
    ./config/home/zsh.nix
  ];

  fonts.fontconfig.enable = true;

  home.packages = [
    # Programming things
    pkgs.rustc
    pkgs.cargo
    pkgs.gccgo13

    # Terminal shit
    pkgs.git
    pkgs.gh
    pkgs.vimPlugins.nvim-treesitter
    pkgs.vimPlugins.nvim-treesitter-parsers.nix
    pkgs.kitty
    pkgs.rio
    pkgs.walk
    pkgs.bat
    pkgs.neofetch
    pkgs.fzf

    # Communications
    pkgs.slack
    pkgs.discord
    pkgs.element-desktop
    pkgs.whatsapp-for-linux

    # Desktop stuff
    pkgs.anytype
    pkgs.spotify
    pkgs.via
    pkgs.obsidian
    pkgs.bitwarden
    # pkgs.dropbox
    pkgs.vlc
    pkgs.gnomeExtensions.appindicator
    pkgs.gnomeExtensions.topicons-plus
    pkgs.gnomeExtensions.blur-my-shell
    pkgs.gnomeExtensions.color-picker
    pkgs.gnomeExtensions.media-controls
    pkgs.gnomeExtensions.vitals
    # with pkgs.gnomeExtensions; [
    #   appindicator
    #   topicons-plus
    # ];

    # Gaming
    pkgs.lutris
    pkgs.steam
    pkgs.thunderbird
    pkgs.prismlauncher

    # Remote stuff
    pkgs.moonlight-qt
    pkgs.parsec-bin
    pkgs.virt-viewer
    pkgs.termius

    # Fonts
    (pkgs.nerdfonts.override { fonts = [ "FiraMono" ]; })
  ];

  home.file.".config/pylint".source = ./config/pylint;
  home.file.".config/pylint".recursive = true;
}
