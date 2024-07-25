# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
# Just testing something

flake-overlays:

{ inputs, config, pkgs,
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
      ../../modules/default
      # <home-manager/nixos>
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.overlays = [] ++ flake-overlays;

  desktop.testing = {
    enable = true;
    bluetooth = true;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };

  networking.hostName = "godshawke"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  boot.initrd.kernelModules = [ "amdgpu" ];

  hardware.opengl.driSupport = true;

  # Enable Docker
  virtualisation.docker.enable = true;

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "archessmn" ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  users.users."archessmn" = {
    isNormalUser = true;
    description = "${gitUsername}";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    ignoreShellProgramCheck = true;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keyFiles = [ /home/archessmn/.ssh/authorized_keys ];
  };

  nixpkgs.config.allowUnfree = true;
  
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

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

  programs.firefox.enable = true;
  programs.steam.enable = true;

  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    # displayManager.sddm.enable = true;
    # desktopManager.plasma5.enable = true;
  };

  programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.gnome.seahorse.out}/libexec/seahorse/ssh-askpass";

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
}
