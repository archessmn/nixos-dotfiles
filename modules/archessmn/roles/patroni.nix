{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.patroni;
in
{
  options.archessmn.roles.patroni = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.patroni = {
      enable = true;
      scope = "postgres";
      name = config.networking.hostName;
      postgresqlPackage = pkgs.postgresql_17;
      nodeIp = "${config.networking.hostName}.wahoo-monster.ts.net";
      # otherNodesIps = [
      #   ""
      # ];
      user = "postgres";
      settings = {
        consul = {
          host = "consul.service.consul:8500";
          url = "http://consul.service.consul:8500";
          register_service = true;
        };

        bootstrap = {
          dcs = {
            ttl = 30;
          };
          users = {
            superuser = {
              username = "postgres";
              password = "postgres";
            };
          };
          method = "initdb";
        };

        postgresql = {
          authentication = {
            replication.username = "patronirep";
            rewind.username = "patronirew";
            superuser = {
              username = "postgres";
              password = "postgres";
            };
          };
          listen = lib.mkForce "127.0.0.1,0.0.0.0,${config.networking.hostName}.wahoo-monster.ts.net";
          pg_hba = [
            "local all all trust"
            "host replication patronirep 100.64.0.0/10 trust"
            "host replication patronirep 127.0.0.1/32 trust"
            "host all all 100.64.0.0/10 trust"
            "host all all 172.28.0.0/16 md5"
            "host all all 172.29.0.0/16 md5"
            "host all all 172.30.0.0/16 md5"
            "host all all 172.31.0.0/16 md5"
            "host all all 127.0.0.1/32 trust"
          ];
        };
      };
    };

    # networking.firewall.allowedTCPPorts = [
    #   5432
    #   8008
    # ];

    users.users.postgres = {
      isSystemUser = true;
      description = "PostgreSQL user";
      group = "postgres";
    };

    users.groups.postgres = { };

    systemd.tmpfiles.rules = [ "d /run/postgresql 0755 postgres" ];
  };
}
