# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot.kernelModules = [ "zfs" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.zfs_unstable ];

  nixpkgs.hostPlatform = system;

  networking.hostName = "temjin";

  archessmn = {
    desktop = {
      enable = false;
    };

    system = {
      bootloader = "systemd";
      docker = true;
    };
  };

  environment.systemPackages = with pkgs; [
    zfs
  ];

  system.stateVersion = "25.11"; # Did you read the comment?

}
