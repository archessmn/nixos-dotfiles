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
    age.secrets.asterisk_extensions_sipcord = {
      file = ../../../secrets/${hostname}/asterisk/extensions_sipcord.conf.age;
      owner = "asterisk";
    };
    age.secrets.asterisk_pjsip_sipcord = {
      file = ../../../secrets/${hostname}/asterisk/pjsip_sipcord.conf.age;
      owner = "asterisk";
    };

    systemd.services.asterisk.serviceConfig.Restart = "always";

    services.asterisk = {
      enable = true;

      confFiles = {
        "extensions.conf" = ''
          [from-internal]
          exten = 100,1,Answer()
          same = n,Wait(1)
          same = n,Playback(hello-world)
          same = n,Hangup()
          exten => 6001,1,Dial(PJSIP/6001,20)
          exten => 6002,1,Dial(PJSIP/6002,20)

          #include ${config.age.secrets.asterisk_extensions_sipcord.path}
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

          [6002]
          type=endpoint
          context=from-internal
          disallow=all
          allow=ulaw
          auth=6002
          aors=6002

          [6002]
          type=auth
          auth_type=userpass
          password=unsecurepassword
          username=6002

          [6002]
          type=aor
          max_contacts=1

          #include ${config.age.secrets.asterisk_pjsip_sipcord.path}
        '';
      };
    };
  };
}
