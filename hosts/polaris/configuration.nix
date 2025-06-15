{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  archessmn = {
    desktop = {
      enable = true;
      virtualBox = true;
    };

    system = {
      bootloader = "grub";
      efiPath = "/boot/efi";
      graphics.brand = "intel";
    };
  };


  networking.hostName = "polaris"; # Define your hostname.

  system.stateVersion = "25.05";
}

