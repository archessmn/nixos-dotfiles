{ lib, config, pkgs, unstablePkgs, ... }:
with lib;
let
  cfg = config.archessmn.desktop;
  userLocale = (import ../../../users.nix).archessmn.localisation;
in
{
  options.archessmn.desktop = {
    defaultLocale = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.defaultLocale {
    # Locale stuff

    time.timeZone = "${userLocale.timezone}";
    i18n.defaultLocale = "${userLocale.locale}";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "${userLocale.locale}";
      LC_IDENTIFICATION = "${userLocale.locale}";
      LC_MEASUREMENT = "${userLocale.locale}";
      LC_MONETARY = "${userLocale.locale}";
      LC_NAME = "${userLocale.locale}";
      LC_NUMERIC = "${userLocale.locale}";
      LC_PAPER = "${userLocale.locale}";
      LC_TELEPHONE = "${userLocale.locale}";
      LC_TIME = "${userLocale.locale}";
    };

    console.keyMap = "uk";
  };
}
