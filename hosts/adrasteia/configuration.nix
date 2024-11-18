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
      virtualBox = true;
    };

    home.home-manager.desktop = {
      activate-linux.enable = true;
      gnome.gsconnect.enable = true;
    };

    system = {
      battery.tlp.enable = true;
      bootloader = "grub";
      efiPath = "/boot/efi";
      fprintd.enable = true;
      graphics.brand = "amd";
      security.kanidm.client.enable = true;
    };
  };

  networking.hostName = "adrasteia"; # Define your hostname.

  system.stateVersion = "23.11";
}
