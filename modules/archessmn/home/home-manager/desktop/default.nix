{ lib, config, pkgs, unstablePkgs, username, ... }:
with lib;
let
  desktopEnabled = config.archessmn.desktop.enable;
  cfg = config.archessmn.home.home-manager.desktop;
in

{
  imports = [
    ./terminals
    ./activate-linux.nix
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

      # Assorted shite
      pkgs.nixfmt-rfc-style
      pkgs.jflap
      pkgs.wireshark

      # Terminal emulators
      pkgs.kitty
      pkgs.rio

      # Communications
      pkgs.slack
      pkgs.beeper
      pkgs.discord
      pkgs.vesktop
      pkgs.signal-desktop
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

      pkgs.libresprite

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
