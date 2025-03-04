{
  inputs,
  config,
  lib,
  pkgs,
  username,
  unstable-pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  archessmn = {
    desktop = {
      enable = false;
    };

    system = {
      bootloader = "hardware-defined";
      docker = true;
      tailscale.advertiseExitNode = true;
    };

    roles = {
      traefik.enable = true;
      uptime-kuma.enable = true;
      vaultwarden.enable = true;
      consul = {
        client.enable = true;
        server.enable = true;
      };
      nomad = {
        server.enable = true;
      };

      kanidm.server.enable = true;

      beszel.hub.enable = true;
    };
  };

  # Manually set IPv6 Address
  networking = {
    dhcpcd = {
      IPv6rs = true;
    };
    interfaces = {
      ens18.useDHCP = true;
      # ens18.ipv4.addresses = [{
      #   address = "185.213.25.136";
      #   prefixLength = 24;
      # }];
      ens18.ipv6.addresses = [
        {
          address = "2a02:c206:2228:4949:0000:0000:0000:0001";
          prefixLength = 64;
        }
      ];
    };

    nameservers = [
      "161.97.189.51"
      "161.97.189.52"
      "2a02:c206:5028::1:53"
      "2a02:c206:5028::2:53"
    ];

    # defaultGateway = {
    #   address = "185.213.25.1";
    #   interface = "ens18";
    # };
    defaultGateway6 = {
      address = "fe80::1";
      interface = "ens18";
    };
  };

  services.resolved.enable = true;

  # Include Agenix Secrets
  age.secrets.traefik_cloudflare_env.file = ../../secrets/traefik_cloudflare.env.age;
  age.secrets.traefik_kanidm_env.file = ../../secrets/traefik_kanidm.env.age;
  age.secrets.vaultwarden_env.file = ../../secrets/vaultwarden.env.age;

  networking.hostName = "tsuro";

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  # networking.domain = "";
  # services.openssh.enable = true;
  # users.users.root.openssh.authorizedKeys.keys = [ ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID7Oux90eiurP5T1vQ9PF6ibIxxzAQBrPB8ZWnuk0Vvb'' ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG0HpThCYE2gOZvrU8sRFqeOKS4llKMzALqx5+T+zxpV'' ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDcmDNjKEltZB9ZTijvfnka09iTJQ5Ro7QXBKhXpC4Ey'' ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMh2mUHL7drQsnB/3q4PDBD6XoQTB6OOr5bXXvqwlxYa'' ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICFI0pAOSkn/deHOz31uavaCWQ770w9Bxv3MVC9Jsts3'' ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICR2wCQqZvFKmKByOGBAAjv4EdsFXvxzbVx0a15EjBpz'' ''sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBB252zkVQgeI4NPUSqt0UzIxicmUspZr2SzPeb18IktFzeqsL/X6+g8AF4lBymuuiJPpMVMmDR9ux10YgW41HFMAAAAEc3NoOg=='' ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBjm5bvRdZcofeBZ/lhke5hIKRAyejACr3tw7LQJUfl7'' ];
  system.stateVersion = "23.11";
}
