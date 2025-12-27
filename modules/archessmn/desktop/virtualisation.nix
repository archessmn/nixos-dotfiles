{
  lib,
  config,
  username,
  ...
}:
with lib;
let
  cfg = config.archessmn.desktop;
in
{
  options.archessmn.desktop = {
    virtualBox = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkMerge [
    (mkIf cfg.virtualBox {
      virtualisation.virtualbox.host.enable = true;
      users.extraGroups.vboxusers.members = [ "${username}" ];
    })
  ];
}
