# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
# Just testing something

{ inputs
, config
, pkgs
, hostname
, gitUsername
, theLocale
, theTimezone
, unstablePkgs
, ...
}:

#let
#  unstable = import
#    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/master)
#    # reuse the current configuration
#    { config = config.nixpkgs.config; };
#in

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/desktop
      # <home-manager/nixos>
    ];

  archessmn.desktop = {
    enable = true;
    graphics.brand = "amd";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "godshawke"; # Define your hostname.

  # Enable Docker
  virtualisation.docker.enable = true;

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "archessmn" ];

  programs.fish.enable = true;

  users.users."archessmn" = {
    isNormalUser = true;
    description = "${gitUsername}";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    ignoreShellProgramCheck = true;
    shell = pkgs.fish;
    openssh.authorizedKeys.keyFiles = [ ../../config/ssh/authorized_keys ];
  };

  environment.systemPackages = [
    pkgs.vim
    pkgs.wget
    pkgs.curl
    pkgs.libimobiledevice
    pkgs.wineWowPackages.full
    pkgs.openrgb
    pkgs.arduino

    unstablePkgs.kanidm
  ];

  services.udev.packages = with pkgs; [
    gnome.gnome-settings-daemon
    via
    moonlight-qt
    parsec-bin
    openrgb
    arduino
    # xilinx-udev-rules
  ];

  system.stateVersion = "24.05";
}
