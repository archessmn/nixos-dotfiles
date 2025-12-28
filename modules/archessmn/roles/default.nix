{
  ...
}:
{

  imports = [
    ./arr
    ./beszel
    ./consul
    ./nomad
    ./book-downloader.nix
    ./booklore.nix
    ./family-pc.nix
    ./frigate.nix
    ./gluetun.nix
    ./grafana.nix
    ./hydra.nix
    ./immich.nix
    ./jellyfin.nix
    ./jellyseer.nix
    ./kanidm.nix
    ./keycloak.nix
    ./patroni.nix
    ./prometheus.nix
    ./qbittorrent.nix
    ./traefik.nix
    ./uptime-kuma.nix
    ./vaultwarden.nix
  ];

  options.archessmn.roles = { };

  config = { };
}
