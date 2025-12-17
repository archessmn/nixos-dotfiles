# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  system,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot.kernelModules = [ "zfs" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.zfs_unstable ];

  boot.zfs.extraPools = [ "deep-storage-pool" ];

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

  networking = {
    useDHCP = false;

    interfaces.enp0s31f6.useDHCP = false;

    bridges = {
      br0 = {
        interfaces = [
          "enp0s31f6"
        ];
      };
    };

    interfaces.br0 = {
      ipv4.addresses = [
        {
          address = "10.0.0.10";
          prefixLength = 8;
        }
      ];
    };

    defaultGateway = "10.0.0.1";
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
    };
  };

  programs.virt-manager.enable = true;

  users.users.archessmn.extraGroups = [
    "libvirtd"
    "kvm"
  ];

  environment.systemPackages = with pkgs; [
    zfs
  ];

  system.stateVersion = "25.11"; # Did you read the comment?

}
