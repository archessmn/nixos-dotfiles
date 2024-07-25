{ lib, config, pkgs, unstablePkgs, theLocale, theTimezone, ...}:
with lib;
let
  cfg = config.desktop.testing;
in {
  options.desktop.testing = {
    enable = mkEnableOption "Testing Modules";

    bluetooth = mkOption {
      type = types.bool;
      default = true;
    };

    tailscale = mkOption {
      type = types.bool;
      default = true;
    };

    ssh = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {

    # Locale stuff

    time.timeZone = "${theTimezone}";

    # Select internationalisation properties
    i18n.defaultLocale = "${theLocale}";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "${theLocale}";
      LC_IDENTIFICATION = "${theLocale}";
      LC_MEASUREMENT = "${theLocale}";
      LC_MONETARY = "${theLocale}";
      LC_NAME = "${theLocale}";
      LC_NUMERIC = "${theLocale}";
      LC_PAPER = "${theLocale}";
      LC_TELEPHONE = "${theLocale}";
      LC_TIME = "${theLocale}";
    };

    console.keyMap = "uk";

    # Hardware stuff

    hardware.bluetooth = mkIf cfg.bluetooth {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
        };
      };
    };

    services.usbmuxd.enable = true;

    # Sound stuff

    security.rtkit.enable = true;

    sound.enable = true;
    hardware.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      audio.enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      jack.enable = true;
    };

    # Networking stuff

    networking.networkmanager.enable = true;

    services.openssh = mkIf cfg.ssh {
      enable = true;
      settings.PasswordAuthentication = false;
      settings.KbdInteractiveAuthentication = false;
    };

    services.tailscale = mkIf cfg.tailscale {
      enable = true;
      package = unstablePkgs.tailscale;
    };
  };
}