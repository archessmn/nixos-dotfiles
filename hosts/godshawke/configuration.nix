{ inputs
, config
, pkgs
, unstablePkgs
, ...
}:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  archessmn.desktop = {
    enable = true;
    virtualBox = true;
  };

  archessmn.system = {
    bootloader = "systemd";
    graphics.brand = "amd";
    wakeonlan = {
      enable = true;
      interface = "enp3s0";
    };
  };

  networking.hostName = "godshawke"; # Define your hostname.

  system.stateVersion = "24.05";
}
