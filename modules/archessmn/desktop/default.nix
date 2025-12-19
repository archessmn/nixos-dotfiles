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
  cfg = config.archessmn.desktop;
in
{

  imports = optionals (!isDarwin) [
    ./sound.nix
    ./virtualisation.nix
  ];

  options.archessmn.desktop = {
    enable = mkEnableOption "Testing Modules";

    isDevMachine = mkOption {
      type = types.bool;
      default = false;
    };

    isCommsMachine = mkOption {
      type = types.bool;
      default = false;
    };

    hyprland = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = optionalAttrs (!isDarwin) (
    mkIf cfg.enable {
      programs.firefox.enable = true;
      programs.steam.enable = true;

      programs.wireshark.enable = true;

      services.xserver = {
        enable = true;
        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;
      };

      programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.seahorse.out}/libexec/seahorse/ssh-askpass";

      programs.hyprland = mkIf cfg.hyprland {
        enable = true;
        xwayland.enable = true;
      };

      services.usbmuxd.enable = true;

      users.users.${username}.extraGroups = [ "gamemode" ];

      environment.systemPackages = [
        pkgs.libimobiledevice
        pkgs.wineWowPackages.full

        unstable-pkgs.kanidm
      ];

      services.udev.packages = with pkgs; [
        gnome-settings-daemon
        via
        moonlight-qt
      ];
    }
  );
}
