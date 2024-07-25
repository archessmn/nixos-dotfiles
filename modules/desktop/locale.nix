{ lib, config, pkgs, unstablePkgs, theLocale, theTimezone, ...}:
with lib;
let
  cfg = config.desktop.testing;
in {
  options.desktop.testing = {
    defaultLocale = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.defaultLocale {
    # Locale stuff

    time.timeZone = "${theTimezone}";
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
  };
}