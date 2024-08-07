{ lib, config, pkgs, unstablePkgs, theLocale, theTimezone, username, ... }:
with lib;
let
  cfg = config.archessmn.desktop;
in
{

  imports = [
    ./graphics.nix
    ./hardware.nix
    ./locale.nix
    ./networking.nix
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
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    nixpkgs.config.permittedInsecurePackages = [
      "electron-25.9.0"
    ];

    nixpkgs.config.allowUnfree = true;

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;


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
  };
}
