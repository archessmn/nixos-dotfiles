{
  system,
  hostname,
  config,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs.hostPlatform = system;

  archessmn = {
    desktop = {
      enable = false;
    };

    system = {
      bootloader = "hardware-defined";
      docker = true;
      tailscale.advertiseExitNode = true;
    };

    home.home-manager.desktop.git.enable = true;
  };

  # Manually set IPv6 Address
  networking = {
    dhcpcd = {
      IPv6rs = true;
    };
    interfaces = {
      ens18.useDHCP = true;
      ens18.ipv4.addresses = [{
        address = "207.180.244.193";
        prefixLength = 18;
      }];
      ens18.ipv6.addresses = [
        {
          address = "2a02:c207:2377:9562::1";
          prefixLength = 64;
        }
      ];
    };

    defaultGateway = {
      address = "207.180.192.1";
      interface = "ens18";
    };

    defaultGateway6 = {
      address = "fe80::1";
      interface = "ens18";
    };
  };

  networking.hostName = "rialto";

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  system.stateVersion = "23.11";
}
