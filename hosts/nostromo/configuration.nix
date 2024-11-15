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
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  archessmn = {
    desktop = {
      enable = true;
      virtualBox = true;
    };

    home.home-manager.desktop = {
      activate-linux.enable = true;
      gnome.gsconnect.enable = true;
    };

    system = {
      bootloader = "grub";
      efiPath = "/boot/efi";
      graphics.brand = "intel";
      thinkpad.enable = true;
    };
  };

  networking.hostName = "nostromo"; # Define your hostname.

  system.stateVersion = "24.05"; # Did you read the comment?

}

