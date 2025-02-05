{
  lib,
  config,
  pkgs,
  unstablePkgs,
  username,
  ...
}:
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

    home.packages =
      with pkgs;
      (mkMerge [
        (mkIf config.archessmn.desktop.isDevMachine [
          # Editors
          jetbrains.idea-ultimate
          chromium
          wireshark
          libresprite
        ])
        (mkIf config.archessmn.desktop.isCommsMachine [
          # Communications
          slack
          beeper
          discord
          vesktop
          signal-desktop
          element-desktop
        ])
        [
          # Assorted shite
          nixfmt-rfc-style

          # Terminal emulators
          kitty

          # Desktop stuff
          spotify
          via
          obsidian
          x32edit
          vlc
          helvum

          # Remote stuff
          moonlight-qt
          parsec-bin

          # Fonts
          (pkgs.nerdfonts.override { fonts = [ "FiraMono" ]; })
        ]
      ]);
  };
}
