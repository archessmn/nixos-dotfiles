{
  lib,
  config,
  pkgs,
  unstable-pkgs,
  username,
  isDarwin,
  ...
}:
with lib;
let
  desktopEnabled = config.archessmn.desktop.enable;
  cfg = config.archessmn.home.home-manager.desktop;
in

{
  imports = [
    ./git.nix
    ./senpai.nix
  ]
  ++ optionals (!isDarwin) [
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

    xdg.desktopEntries = {
      jellyfin = {
        name = "Jellyfin";
        exec = "firefox https://media.moir.xyz";
        categories = [
          "Application"
        ];
      };
      jellyseerr = {
        name = "Jellyseerr";
        genericName = "Request";
        exec = "firefox https://request.moir.xyz";
        categories = [
          "Application"
        ];
      };
      sonarr = {
        name = "Sonarr";
        exec = "firefox https://sonarr.moir.xyz";
        categories = [
          "Application"
        ];
      };
      radarr = {
        name = "Radarr";
        exec = "firefox https://radarr.moir.xyz";
        categories = [
          "Application"
        ];
      };
      x32edit = {
        name = "X32 Edit";
        exec = "${unstable-pkgs.x32edit}/bin/x32-edit";
        categories = [
          "Application"
        ];
      };
    };

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
          discord
          element-desktop
          mumble
          signal-desktop
          slack
        ])
        [
          # Assorted shite
          nixfmt-rfc-style

          # Terminal emulators
          kitty
          ghostty

          # Desktop stuff
          spotify
          via
          obsidian
          unstable-pkgs.x32edit
          vlc
          helvum

          # Remote stuff
          moonlight-qt
          parsec-bin

          # Fonts
          pkgs.nerd-fonts.fira-mono
        ]
      ]);
  };
}
