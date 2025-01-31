{
  inputs,
  config,
  pkgs,
  username,
  hostname,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  archessmn = {
    desktop = {
      enable = true;
    };

    home.home-manager.desktop = {
      activate-linux.enable = true;
    };

    system = {
      battery.tlp.enable = true;
      bootloader = "grub";
      efiPath = "/boot/efi";
      fprintd = {
        enable = true;
        tod = {
          enable = true;
          driver = pkgs.libfprint-2-tod1-vfs0090;
        };
      };
      graphics.brand = "nvidia-special";
    };
  };

  boot.loader.grub.enableCryptodisk = true;

  boot.initrd.luks.devices.cryptroot.device =
    "/dev/disk/by-uuid/72ad0d21-cfeb-4ca3-83ff-1a9788014a00";

  networking.hostName = "honkpad"; # Define your hostname.

  system.stateVersion = "23.11";
}
