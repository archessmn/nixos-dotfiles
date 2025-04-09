{
  inputs,
  config,
  lib,
  pkgs,
  username,
  unstable-pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.supportedFilesystems = [ "ntfs" ];
  boot.loader.grub.useOSProber = true;

  networking.firewall.allowedUDPPorts = [ 8004 ];

  archessmn = {
    desktop = {
      enable = true;
      virtualBox = true;
      isDevMachine = true;
      isCommsMachine = true;
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
      security.agenix.enable = true;
    };

    roles = {
      consul.client.enable = true;
    };
  };

  home-manager.users.${username}.home.packages = with pkgs; [
    obs-studio
  ];

  # services.unifi = {
  #   enable = true;
  #   openFirewall = true;
  #   mongodbPackage = pkgs.mongodb-ce;
  #   unifiPackage = unstable-pkgs.unifi;
  # };

  programs.winbox = {
    enable = true;
    package = pkgs.winbox4;
    openFirewall = true;
  };

  networking.hostName = "adrasteia"; # Define your hostname.

  system.stateVersion = "23.11";
}
