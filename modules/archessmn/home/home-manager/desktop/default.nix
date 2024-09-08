{ lib, config, pkgs, unstablePkgs, username, ... }:
with lib;
let
  desktopEnabled = config.archessmn.desktop.enable;
  cfg = config.archessmn.home.home-manager.desktop;
in

{
  imports = [
    ./terminals
    ./gaming.nix
    ./git.nix
    ./gnome.nix
    ./hyperion.nix
    ./vscode.nix
  ];

  options.archessmn.home.home-manager.desktop = {
    enable = mkOption {
      type = types.bool;
      default = desktopEnabled;
    };
  };

  config.home-manager.users.${username} = mkIf cfg.enable {
    fonts.fontconfig.enable = true;

    # home.file.".config/kanidm".source = ../files/kanidm;

    home.packages = [
      # Editors
      pkgs.jetbrains.idea-ultimate
      pkgs.zed-editor

      # Assorted shite
      pkgs.jflap

      # Terminal emulators
      pkgs.kitty
      pkgs.rio

      # Communications
      pkgs.slack
      pkgs.discord
      pkgs.vesktop
      pkgs.element-desktop
      pkgs.whatsapp-for-linux

      # Security stuff
      # unstablePkgs.kanidm
      pkgs.bitwarden

      # Desktop stuff
      pkgs.anytype
      pkgs.spotify
      pkgs.via
      pkgs.obsidian
      pkgs.x32edit
      pkgs.vlc
      pkgs.helvum
      pkgs.chromium

      # Remote stuff
      pkgs.moonlight-qt
      pkgs.parsec-bin
      pkgs.virt-viewer
      pkgs.termius

      # Fonts
      (pkgs.nerdfonts.override { fonts = [ "FiraMono" ]; })
    ];
  };
}
