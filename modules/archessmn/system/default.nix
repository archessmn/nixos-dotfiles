{ lib, config, pkgs, unstablePkgs, theLocale, theTimezone, username, ... }:
with lib;
let
  cfg = config.archessmn.system;
in
{

  imports = [
    ./security
    ./bluetooth.nix
    ./fprintd.nix
    ./graphics.nix
    ./locale.nix
    ./networking.nix
    ./power.nix
    ./virtualisation.nix
  ];

  options.archessmn.system = {
    enable = mkEnableOption "Testing Modules";

    bootloader = mkOption {
      type = types.enum [ "systemd" "grub" ];
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      nix.settings.experimental-features = [ "nix-command" "flakes" ];

      nixpkgs.config.allowUnfree = true;

      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;

      environment.systemPackages = [
        pkgs.vim
        pkgs.wget
        pkgs.curl
        pkgs.git
      ];
    })
    (mkIf
      (cfg.bootloader
        == "systemd")
      {
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
      })
    (mkIf (cfg.bootloader == "grub")
      {
        boot.loader = {
          efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/boot/efi";
          };
          grub = {
            efiSupport = true;
            device = "nodev";
            minegrub-theme = {
              enable = true;
              splash = "100% flakes!";
              background = "background_options/1.8  - [Classic Minecraft].png";
              boot-options-count = 4;
            };
          };
        };
      })
  ];
}
