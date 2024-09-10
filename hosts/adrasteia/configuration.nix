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
    };

    system = {
      battery.tlp.enable = true;
      bootloader = "systemd";
      fprintd = true;
      graphics.brand = "amd";
    };
  };

  networking.hostName = "adrasteia"; # Define your hostname.

  system.stateVersion = "23.11";
}
