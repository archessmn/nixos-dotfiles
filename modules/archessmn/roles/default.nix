{
  ...
}:
{

  imports = [
    ./arr
    ./beszel
    ./consul
    ./nomad
    ./booklore.nix
    ./family-pc.nix
    ./frigate.nix
    ./gluetun.nix
    ./immich.nix
    ./jellyfin.nix
    ./jellyseer.nix
    ./kanidm.nix
    ./keycloak.nix
    ./patroni.nix
    ./qbittorrent.nix
    ./traefik.nix
    ./uptime-kuma.nix
    ./vaultwarden.nix
  ];

  options.archessmn.roles = { };

  config = { };
}
