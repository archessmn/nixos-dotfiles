# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
# Just testing something

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

  networking.hostName = "zenith"; # Define your hostname.

  system.stateVersion = "23.11";
}
