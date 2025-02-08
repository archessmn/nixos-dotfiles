{
  inputs,
  config,
  pkgs,
  unstable-pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  archessmn.desktop = {
    enable = true;
    virtualBox = true;
  };

  archessmn.system = {
    bootloader = "grub";
    efiPath = "/boot/efi";
    graphics.brand = "amd";
    wakeonlan = {
      enable = true;
      interface = "enp3s0";
    };
    security.kanidm.client.enable = true;
  };

  networking.hostName = "godshawke"; # Define your hostname.

  system.stateVersion = "24.05";
}
