{
  lib,
  config,
  pkgs,
  username,
  ...
}:
with lib;
let
  desktopEnabled = config.archessmn.desktop.enable;
  cfg = config.archessmn.home.home-manager.desktop.gnome;
in

{
  options.archessmn.home.home-manager.desktop.gnome = {
    enable = mkOption {
      type = types.bool;
      default = desktopEnabled;
    };

    dconf.enable = mkOption {
      type = types.bool;
      default = cfg.enable;
    };

    gsconnect.enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {

    programs.kdeconnect = mkIf cfg.gsconnect.enable {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };

    home-manager.users.${username} =
      { lib, ... }:
      {
        home.packages = with pkgs.gnomeExtensions; [
          # Gnome stuff
          appindicator
          blur-my-shell
          caffeine
          color-picker
          gsconnect
          home-assistant-extension
          media-controls
          quick-settings-tweaker
          steal-my-focus-window
          topicons-plus
          vitals
          tailscale-qs
        ];

        services.kdeconnect = mkIf cfg.gsconnect.enable {
          enable = true;
          indicator = true;
          package = pkgs.gnomeExtensions.gsconnect;
        };

        dconf = mkIf cfg.dconf.enable {
          enable = true;
          settings."org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            show-battery-percentage = true;
          };

          # Enabled extensions
          settings."org/gnome/shell" = {
            disabled-extensions = [
              "apps-menu@gnome-shell-extensions.gcampax.github.com"
              "drive-menu@gnome-shell-extensions.gcampax.github.com"
              "light-style@gnome-shell-extensions.gcampax.github.com"
              "native-window-placement@gnome-shell-extensions.gcampax.github.com"
              "places-menu@gnome-shell-extensions.gcampax.github.com"
              "screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com"
              "window-list@gnome-shell-extensions.gcampax.github.com"
              "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
            ];
            enabled-extensions = [
              "appindicatorsupport@rgcjonas.gmail.com"
              "Battery-Health-Charging@maniacx.github.com"
              "blur-my-shell@aunetx"
              "caffeine@patapon.info"
              "color-picker@tuberry"
              "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
              "mediacontrols@cliffniff.github.com"
              "tailscale@joaophi.github.com"
              "Vitals@CoreCoding.com"
              "windowsNavigator@gnome-shell-extensions.gcampax.github.com"
            ];
            favorite-apps = [
              "firefox.desktop"
              "thunderbird.desktop"
              "spotify.desktop"
              "org.gnome.Nautilus.desktop"
              "kitty.desktop"
              "org.prismlauncher.PrismLauncher.desktop"
              "code.desktop"
              "slack.desktop"
              "discord.desktop"
            ];
          };

          # Keybindings
          settings."org/gnome/desktop/wm/keybindings" = {
            panel-run-dialog = [ "<Super>R" ];
            switch-applications = [ "<Super>Tab" ];
            switch-applications-backward = [ "<Shift><Super>Tab" ];
            switch-windows = [ "<Alt>Tab" ];
            switch-windows-backward = [ "<Alt><Shift>Tab" ];
            toggle-fullscreen = [ "F11" ];
          };

          settings."org/gnome/desktop/input-sources" = {
            sources = [
              (lib.hm.gvariant.mkTuple [
                "xkb"
                "gb"
              ])
            ];
          };

          settings."org/gnome/desktop/wm/preferences" = {
            button-layout = "appmenu:minimize,maximize,close";
            visual-bell = false;
          };

          # Blur My Shell
          settings."org/gnome/shell/extensions/blur-my-shell" = {
            brightness = 0.69;
            hacks-level = 3;
            noise-amount = 0.2;
            noise-lightness = 0.69;
            sigma = 45;
          };

          settings."org/gnome/shell/extensions/blur-my-shell/applications" = {
            blacklist = [ "Plank" ];
            blur-on-overview = false;
            brightness = 0.8;
            enable-all = false;
            opacity = 230;
            sigma = 6;
            whitelist = [ "kitty" ];
          };

          settings."org/gnome/shell/extensions/blur-my-shell/overview" = {
            blur = true;
            style-components = 3;
          };

          settings."org/gnome/shell/extensions/blur-my-shell/panel" = {
            override-background = true;
          };

          # Color Picker
          settings."org/gnome/shell/extensions/color-picker" = {
            default-format = 0;
            enable-shortcut = true;
            enable-systray = true;
            menu-size = 1;
          };

          # Media Controls
          settings."org/gnome/shell/extensions/mediacontrols" = {
            colored-player-icon = false;
            extension-index = 0;
            extension-position = "right";
            hide-media-notification = true;
            max-widget-width = 200;
            mouse-actions = [
              "toggle_info"
              "toggle_menu"
              "raise"
              "none"
              "none"
              "none"
              "none"
              "none"
            ];
            scroll-track-label = true;
            show-player-icon = false;
            show-seek-back = false;
            show-seek-forward = false;
            show-seperators = false;
            show-sources-menu = false;
            track-label = [
              "track"
              "-"
              "artist"
            ];
          };

          # Vitals
          settings."org/gnome/shell/extensions/vitals" = {
            alphabetize = true;
            hide-icons = false;
            hide-zeros = false;
            hot-sensors = [
              "_processor_usage_"
              "_processor_frequency_"
              "__temperature_avg__"
              "_memory_usage_"
            ];
            menu-centered = false;
            position-in-panel = 0;
            show-battery = false;
            show-memory = true;
            update-time = 3;
            use-higher-precision = true;
          };

          settings."org/gnome/shell/extensions/quick-settings-tweaks" = {
            input-always-show = false;
            input-show-selected = true;
            list-buttons = "[{\"name\":\"SystemItem\",\"title\":null,\"visible\":true},{\"name\":\"OutputStreamSlider\",\"title\":null,\"visible\":true},{\"name\":\"InputStreamSlider\",\"title\":null,\"visible\":false},{\"name\":\"St_BoxLayout\",\"title\":null,\"visible\":true},{\"name\":\"BrightnessItem\",\"title\":null,\"visible\":true},{\"name\":\"NMWiredToggle\",\"title\":null,\"visible\":false},{\"name\":\"NMWirelessToggle\",\"title\":\"Wi-Fi\",\"visible\":true},{\"name\":\"NMModemToggle\",\"title\":null,\"visible\":false},{\"name\":\"NMBluetoothToggle\",\"title\":null,\"visible\":false},{\"name\":\"NMVpnToggle\",\"title\":\"VPN\",\"visible\":true},{\"name\":\"BluetoothToggle\",\"title\":\"Bluetooth\",\"visible\":true},{\"name\":\"PowerProfilesToggle\",\"title\":\"Power Mode\",\"visible\":false},{\"name\":\"NightLightToggle\",\"title\":\"Night Light\",\"visible\":true},{\"name\":\"DarkModeToggle\",\"title\":\"Dark Style\",\"visible\":true},{\"name\":\"KeyboardBrightnessToggle\",\"title\":\"Keyboard\",\"visible\":false},{\"name\":\"RfkillToggle\",\"title\":\"Aeroplane Mode\",\"visible\":true},{\"name\":\"RotationToggle\",\"title\":\"Auto Rotate\",\"visible\":false},{\"name\":\"DndQuickToggle\",\"title\":\"Do Not Disturb\",\"visible\":true},{\"name\":\"BackgroundAppsToggle\",\"title\":\"No Background Apps\",\"visible\":false},{\"name\":\"MediaSection\",\"title\":null,\"visible\":false},{\"name\":\"Notifications\",\"title\":null,\"visible\":false}]";
            output-show-selected = true;
            volume-mixer-enabled = true;
            volume-mixer-position = "top";
          };

          # Window List
          settings."org/gnome/shell/extensions/window-list" = {
            display-all-workspaces = false;
            grouping-mode = "never";
          };

          # Active Screen Edges
          settings."org/gnome/mutter" = {
            edge-tiling = true;
            experimental-features = [
              "scale-monitor-framebuffer"
              "xwayland-native-scaling"
            ];
          };
        };
      };
  };
}
