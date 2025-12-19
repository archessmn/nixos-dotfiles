{
  lib,
  config,
  pkgs,
  isDarwin,
  ...
}:
with lib;
let
  cfg = config.archessmn.system.ssh;
in
{
  options.archessmn.system.ssh = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };

    yubikeyRootAuth = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    services.openssh = (
      mkMerge [
        {
          enable = true;
        }
        (optionalAttrs (!isDarwin) {
          settings.PasswordAuthentication = false;
          settings.KbdInteractiveAuthentication = false;
        })
        (optionalAttrs isDarwin {
          extraConfig = ''
            PermitRootLogin no
            PasswordAuthentication no
            PermitEmptyPasswords no
            KbdInteractiveAuthentication no
          '';
        })

      ]
    );

    users.users.root.openssh.authorizedKeys.keys = mkIf (cfg.enable && cfg.yubikeyRootAuth) [
      ''sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBB252zkVQgeI4NPUSqt0UzIxicmUspZr2SzPeb18IktFzeqsL/X6+g8AF4lBymuuiJPpMVMmDR9ux10YgW41HFMAAAAEc3NoOg==''
    ];
  };
}
