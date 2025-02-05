{
  inputs,
  config,
  pkgs,
  username,
  hostname,
  unstablePkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  archessmn.desktop = {
    enable = true;
    virtualBox = true;
    isDevMachine = true;
    isCommsMachine = true;
  };

  archessmn.home.home-manager.desktop = {
    hyperion = {
      enable = true;
      firewall.json-server.open = true;
    };

    gnome.gsconnect.enable = true;

    activate-linux.enable = false;
  };

  archessmn.system = {
    bootloader = "grub";
    efiPath = "/boot/efi";
    graphics.brand = "nvidia";
    wakeonlan = {
      enable = true;
      interface = "enp68s0";
    };
    security.kanidm.client.enable = true;
  };

  archessmn.roles = {
    consul.client.enable = true;
  };

  networking.hostName = "zenith";

  system.stateVersion = "23.11";
}
