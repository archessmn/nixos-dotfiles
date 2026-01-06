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

  virtualisation.libvirtd.enable = true;

  programs.virt-manager.enable = true;

  users.extraGroups.libvirtd.members = [ "archessmn" ];

  archessmn = {
    desktop = {
      enable = true;
      # virtualBox = true;
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
    gnome-boxes
  ];

  # services.globalprotect = {
  #   enable = true;
  # };

  # services.unifi = {
  #   enable = true;
  #   openFirewall = true;
  #   mongodbPackage = pkgs.mongodb-ce;
  #   unifiPackage = unstable-pkgs.unifi;
  # };

  services.samba = {
    enable = true;

    settings = {
      global = {
        "map to guest" = "Bad User";
        "guest account" = "nobody";
        "security" = "user";
        "server min protocol" = "NT1"; # For better Windows compatibility
      };

      vmshare = {
        path = "/home/archessmn/vmshare";
        browseable = true;
        writable = true;
        "guest ok" = true;
      };
    };
  };

  networking.firewall.interfaces."virbr0".allowedTCPPorts = [
    139
    445
  ];

  programs.winbox = {
    enable = true;
    package = pkgs.winbox4;
    openFirewall = true;
  };

  networking.hostName = "adrasteia"; # Define your hostname.

  system.stateVersion = "23.11";
}
