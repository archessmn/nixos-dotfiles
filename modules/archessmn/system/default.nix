{
  lib,
  config,
  pkgs,
  unstable-pkgs,
  username,
  flakeDir,
  ...
}:
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
    ./nh.nix
    ./power.nix
    ./thinkpad.nix
    ./virtualisation.nix
  ];

  options.archessmn.system = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };

    bootloader = mkOption {
      type = types.enum [
        "systemd"
        "grub"
        "hardware-defined"
      ];
    };

    efiPath = mkOption {
      type = types.enum [
        "/boot/efi"
        "/boot"
      ];
      default = "/boot";
    };

  };

  config = mkMerge [
    (mkIf cfg.enable {
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      nixpkgs.config.allowUnfree = true;

      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;

      environment.systemPackages = [
        pkgs.vim
        pkgs.wget
        pkgs.curl
        pkgs.git
      ];

      environment.enableAllTerminfo = true;
    })
    (mkIf (cfg.bootloader == "systemd") {
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
    })
    (mkIf (cfg.bootloader == "grub") {
      boot.loader = {
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = cfg.efiPath;
        };
        grub = {
          efiSupport = true;
          device = lib.mkDefault "nodev";
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
