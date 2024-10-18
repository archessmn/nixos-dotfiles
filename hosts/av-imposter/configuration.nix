{ inputs
, config
, lib
, pkgs
, username
, unstablePkgs
, ...
}:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  archessmn = {
    desktop = {
      enable = true;
    };

    system = {
      bootloader = "grub";
      efiPath = "/boot/efi";
      graphics.brand = "intel-old";
    };
  };

  networking.hostName = "av-imposter"; # Define your hostname.

  system.stateVersion = "23.11";
}
