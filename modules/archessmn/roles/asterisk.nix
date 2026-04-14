# Testing Asterisk stuff

{
  hostname,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.asterisk;
in
{
  options.archessmn.roles.asterisk = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.asterisk = {
      enable = true;

      confFiles = {
        "extensions.conf" = ''
          [from-internal]
          exten = 100,1,Answer()
          same = n,Wait(1)
          same = n,Playback(hello-world)
          same = n,Hangup()
        '';

        "pjsip.conf" = ''
          [transport-udp]
          type=transport
          protocol=udp
          bind=0.0.0.0

          [6001]
          type=endpoint
          context=from-internal
          disallow=all
          allow=ulaw
          auth=6001
          aors=6001

          [6001]
          type=auth
          auth_type=userpass
          password=unsecurepassword
          username=6001

          [6001]
          type=aor
          max_contacts=1
        '';
      };
    };
  };
}
