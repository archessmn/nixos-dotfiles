{ lib, config, pkgs, unstablePkgs, theLocale, theTimezone, username, ... }:
with lib;
let
  cfg = config.archessmn.system;
in
{
  options.archessmn.system = {
    battery.tlp.enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkMerge [
    (mkIf cfg.battery.tlp.enable
      {
        services.power-profiles-daemon.enable = false;
        services.tlp = {
          enable = true;
          settings = {
            CPU_SCALING_GOVERNOR_ON_AC = "performance";
            CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

            CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
            CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

            CPU_MIN_PERF_ON_AC = 0;
            CPU_MAX_PERF_ON_AC = 100;
            CPU_MIN_PERF_ON_BAT = 0;
            CPU_MAX_PERF_ON_BAT = 40;

            #Optional helps save long term battery health
            START_CHARGE_THRESH_BAT0 = 80; # 40 and bellow it starts to charge
            STOP_CHARGE_THRESH_BAT0 = 90; # 80 and above it stops charging
          };
        };
      })

  ];
}
