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

  services.tailscale.extraUpFlags = "--advertise-routes=10.0.3.0/24";

  networking.hostName = "av-imposter"; # Define your hostname.

  system.stateVersion = "23.11";
}
