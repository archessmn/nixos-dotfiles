{ lib, config, pkgs, unstablePkgs, ... }:
with lib;
let
  cfg = config.desktop.testing;
in
{
  options.desktop.testing = {
    enable = mkEnableOption "Testing Modules";
    enableOtherThing = {
      yep = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      environment.systemPackages = [
        pkgs.cmatrix
      ];
    })
    (mkIf cfg.enableOtherThing.yep {
      environment.systemPackages = [
        pkgs.butt
      ];
    })
  ];

  # config = mkIf cfg.enable {
  #   environment.systemPackages = mkIf cfg.fuckThat (mkMerge [
  #     [
  #       pkgs.cmatrix
  #     ]
  #     (mkIf cfg.enableOtherThing.yep [
  #       pkgs.butt
  #     ])
  #   ]);
  # };
}
