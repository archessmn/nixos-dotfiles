{
  ...
}:
{

  imports = [
    ./arr
    ./beszel
    ./consul
    ./minecraft/_default.nix
    ./nomad
    ./acme.nix
    ./assets.nix
    ./asterisk.nix
    ./book-downloader.nix
    ./booklore.nix
    ./family-pc.nix
    ./firefly-iii.nix
    ./frigate.nix
    ./gluetun-protonvpn.nix
    ./gluetun.nix
    ./grafana.nix
    ./hummer.nix
    ./immich.nix
    ./jellyfin.nix
    ./seerr.nix
    ./jenkins.nix
    ./kanidm.nix
    ./keycloak.nix
    ./patroni.nix
    ./prometheus.nix
    ./qbittorrent.nix
    ./snowflake-proxy.nix
    ./soju.nix
    ./traefik.nix
    ./uptime-kuma.nix
    ./vaultwarden.nix
  ];

  options.archessmn.roles = { };

  config = { };
}
