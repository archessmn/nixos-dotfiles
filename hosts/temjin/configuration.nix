{
  hostname,
  pkgs,
  system,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot.kernelModules = [ "zfs" ];

  # boot.zfs.extraPools = [ "deep-storage-pool" ];

  nixpkgs.hostPlatform = system;

  networking.hostName = "temjin";
  networking.hostId = "12854296";

  archessmn = {
    desktop = {
      enable = false;
    };

    system = {
      bootloader = "systemd";
      docker = true;

      security.agenix.enable = true;
    };

    home.home-manager.desktop.git.enable = true;

    roles = {
      traefik.enable = true;

      frigate.enable = true;

      gluetun.enable = true;
      qbittorrent.enable = true;

      consul = {
        client.enable = true;
      };

      immich = {
        enable = true;
        uploadLocation = "/deep-storage-pool/immich";
      };

      jellyfin.enable = true;
      jellyseer.enable = true;

      patroni.enable = true;

      arr = {
        prowlarr.enable = true;
        radarr.enable = true;
        readarr.enable = true;
        sonarr.enable = true;
      };
    };
  };

  age.secrets.gluetun_env.file = ../../secrets/${hostname}_gluetun.env.age;
  age.secrets.qbittorrent_env.file = ../../secrets/${hostname}_qbittorrent.env.age;
  age.secrets.traefik_cloudflare_env.file = ../../secrets/${hostname}_traefik_cloudflare.env.age;
  age.secrets.traefik_kanidm_env.file = ../../secrets/${hostname}_traefik_kanidm.env.age;

  networking = {
    useDHCP = false;

    interfaces.enp0s31f6.useDHCP = false;

    bridges = {
      br0 = {
        interfaces = [
          "enp0s31f6"
        ];
      };
    };

    interfaces.br0 = {
      ipv4.addresses = [
        {
          address = "10.0.0.10";
          prefixLength = 8;
        }
      ];
      ipv6.addresses = [
        {
          address = "2a02:6b67:e841:4900::10";
          prefixLength = 64;
        }
      ];
    };

    # "2a02:6b67:e841:4900::10/64"

    defaultGateway = "10.0.0.1";
    defaultGateway6 = {
      address = "2a02:6b67:e841:4900::1";
      interface = "br0";
    };
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu;
      runAsRoot = true;
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  programs.virt-manager.enable = true;

  users.users.archessmn.extraGroups = [
    "libvirtd"
    "kvm"
  ];

  hardware.coral.pcie.enable = true;

  environment.systemPackages = with pkgs; [
    zfs
  ];

  system.stateVersion = "25.11";
}
