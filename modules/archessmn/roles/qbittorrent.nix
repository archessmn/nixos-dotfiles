{
  lib,
  config,
  hostname,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.qbittorrent;

  gluetunContainerName = "gluetun";
in
{
  options.archessmn.roles.qbittorrent = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    age.secrets.qbittorrent-labels.file = ../../../secrets/${hostname}/qbittorrent-labels.age;

    virtualisation.oci-containers.backend = "docker";

    virtualisation.oci-containers.containers.qbittorrent = {
      autoStart = true;

      image = "lscr.io/linuxserver/qbittorrent:5.2.3";

      volumes = [
        "/opt/qbittorrent/config:/config"
        "/deep-storage-pool/qbittorrent-data:/downloads"
      ];

      networks = [
        "container:${gluetunContainerName}"
      ];

      environmentFiles = [
        config.age.secrets.qbittorrent_env.path
      ];

      extraOptions = [
        "--label-file ${config.age.secrets.qbittorrent-labels.path}"
      ];

      # labels = {
      #   "traefik.enable" = "true";
      #   "traefik.http.routers.qbittorrent.rule" = "Host(`qbt.moir.xyz`)";
      #   "traefik.http.routers.qbittorrent.middlewares" = "oidc-qbt-moir-xyz@file";
      #   "traefik.http.services.qbittorrent.loadbalancer.server.port" = "49893";
      # };
    };

    # services.traefik = {
    #   dynamicConfigOptions = {
    #     http = {
    #       middlewares = {
    #         oidc-qbt-moir-xyz = {
    #           plugin = {
    #             traefik-oidc-auth = {
    #               providerURL = "\${TEST_ENV_VAR}";
    #               clientID = "qbittorrent";
    #               audience = "traefik-oidc";
    #               scopes = [
    #                 "openid"
    #                 "profile"
    #                 "email"
    #                 "offline_access"
    #               ];
    #               clientSecret = "\${OIDC_QBT_MOIR_XYZ_SECRET}";
    #               sessionEncryptionKey = "\${OIDC_QBT_MOIR_XYZ_SESSION_KEY}";
    #               callbackURL = "/oauth2/callback";
    #               cookieDomain = "qbt.moir.xyz";
    #               cookiePrefix = "_oidc_qbt_moir_xyz_";
    #               enablePkce = true;
    #             };
    #           };
    #         };
    #       };
    #     };
    #   };
    # };

    virtualisation.oci-containers.containers.${gluetunContainerName}.ports = [
      "49893:49893"
    ];

    systemd.services."docker-qbittorrent" = {
      after = [ "docker-${gluetunContainerName}.service" ];
      requires = [ "docker-${gluetunContainerName}.service" ];
      bindsTo = [ "docker-${gluetunContainerName}.service" ];
      partOf = [ "docker-${gluetunContainerName}.service" ];
    };

    # TODO: qbittorrent-exporter
  };
}
