{ config, lib, pkgs, ... }:

{
  services.patroni = {
    enable = true;
    scope = "dc0-postgres";
    name = config.networking.hostName;
    postgresqlPackage = pkgs.postgresql_14;
    nodeIp = "${config.networking.hostName}.tail76d77.ts.net";
    otherNodesIps = [
      "nixos-103-bishop.tail76d77.ts.net"
      "nixos-104-bishop.tail76d77.ts.net"
      "nixos-105-bishop.tail76d77.ts.net"
      "nixos-200-bishop.tail76d77.ts.net"
    ];
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
        listen = lib.mkForce "127.0.0.1,0.0.0.0,${config.networking.hostName}.tail76d77.ts.net";
        pg_hba = [
          "local all all trust"
          "host replication patronirep 100.0.0.0/8 trust"
          "host replication patronirep 127.0.0.1/32 trust"
          "host all all 100.0.0.0/8 trust"
          "host all all 172.16.0.0/16 password"
          "host all all 127.0.0.1/32 trust"
        ];
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    5432
    8008
  ];

  users.users.postgres = {
    isSystemUser = true;
    description = "PostgreSQL user";
    group = "postgres";
  };

  users.groups.postgres = {};

  systemd.tmpfiles.rules = [ "d /run/postgresql 0755 postgres" ];
}
