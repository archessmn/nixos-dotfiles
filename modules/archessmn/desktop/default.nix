{ lib, config, pkgs, unstablePkgs, username, ... }:
with lib;
let
  cfg = config.archessmn.desktop;
in
{

  imports = [
    ./sound.nix
    ./virtualisation.nix
  ];

  options.archessmn.desktop = {
    enable = mkEnableOption "Testing Modules";

    hyprland = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.config.permittedInsecurePackages = [
      "electron-25.9.0"
    ];

    programs.firefox.enable = true;
    programs.steam.enable = true;


    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

    programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.gnome.seahorse.out}/libexec/seahorse/ssh-askpass";

    programs.hyprland = mkIf cfg.hyprland {
      enable = true;
      xwayland.enable = true;
    };

    services.usbmuxd.enable = true;

    users.users.${username}.extraGroups = [ "gamemode" ];


    environment.systemPackages = [
      pkgs.libimobiledevice
      pkgs.wineWowPackages.full

      unstablePkgs.kanidm
    ];

    services.udev.packages = with pkgs; [
      gnome.gnome-settings-daemon
      via
      moonlight-qt
    ];
  };
}