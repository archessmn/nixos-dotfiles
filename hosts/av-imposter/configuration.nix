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
    system = {
      bootloader = "grub";
      efiPath = "/boot/efi";
      graphics.brand = "intel-old";

      tailscale.advertiseExitNode = true;
    };
  };

  networking.hostName = "av-imposter"; # Define your hostname.

  system.stateVersion = "23.11";
}
