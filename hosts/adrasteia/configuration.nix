# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
# Just testing something

{ inputs, config, pkgs, username,
  hostname, gitUsername, theLocale,
  theTimezone, unstablePkgs, ... }:

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

  desktop.testing = {
    enable = true;
    graphics.brand = "amd";
    docker = true;
    virtualBox = true;
    fprintd = true;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "adrasteia"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 40;

      #Optional helps save long term battery health
      START_CHARGE_THRESH_BAT0 = 80; # 40 and bellow it starts to charge
      STOP_CHARGE_THRESH_BAT0 = 90; # 80 and above it stops charging
    };
  };

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  programs.fish.enable = true;

  users.users."${username}" = {
    isNormalUser = true;
    description = "${gitUsername}";
    extraGroups = [ "networkmanager" "wheel" ];
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
  ];

  system.stateVersion = "23.11";
}
