{ inputs
, config
, pkgs
, username
, hostname
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
    graphics.brand = "nvidia";
    wakeonlan = {
      enable = true;
      interface = "enp68s0";
    };
    security.kanidm.client.enable = true;
  };

  networking.hostName = "zenith";

  system.stateVersion = "23.11";
}
