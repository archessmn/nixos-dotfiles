# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
# Just testing something

{
  inputs,
  config,
  pkgs,
  username,
  hostname,
  gitUsername,
  theLocale,
  theTimezone,
  ...
}:

let
  unstable =
    import (builtins.fetchTarball "https://github.com/nixos/nixpkgs/tarball/master")
      # reuse the current configuration
      { config = config.nixpkgs.config; };
in

{
  imports = [
    ./hardware-configuration.nix
    # <home-manager/nixos>
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.trusted-users = [ "archessmn" ];

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

  security.sudo.extraRules = [
    {
      users = [ "archessmn" ];
      runAs = "ALL:ALL";
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  networking.hostName = "slowpoke"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.networkmanager.enable = true;

  time.timeZone = "${theTimezone}";

  # Select internationalisation properties
  i18n.defaultLocale = "${theLocale}";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "${theLocale}";
    LC_IDENTIFICATION = "${theLocale}";
    LC_MEASUREMENT = "${theLocale}";
    LC_MONETARY = "${theLocale}";
    LC_NAME = "${theLocale}";
    LC_NUMERIC = "${theLocale}";
    LC_PAPER = "${theLocale}";
    LC_TELEPHONE = "${theLocale}";
    LC_TIME = "${theLocale}";
  };

  console.keyMap = "uk";

  hardware.opengl.driSupport = true;

  # Enable Docker
  virtualisation.docker.enable = true;

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  users.users."${username}" = {
    isNormalUser = true;
    description = "${gitUsername}";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    ignoreShellProgramCheck = true;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keyFiles = [ "/home/${username}/.ssh/authorized_keys" ];
  };

  nixpkgs.config.allowUnfree = true;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  # home-manager.users.archessmn = { pkgs, ... }: {
  #   # environment.variable.EDITOR = "nvim";
  #   fonts.fontconfig.enable = true;

  #   home.stateVersion = "23.05";
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    gnomeExtensions.screen-rotate

    tailscale
  ];

  services.udev.packages = with pkgs; [
    gnome-settings-daemon
    via
    moonlight-qt
    parsec-bin
  ];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  services.tailscale.enable = true;

  networking.firewall = {
    logReversePathDrops = true;
    extraCommands = ''
      ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN
      ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN
    '';
    extraStopCommands = ''
      ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
      ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
    '';
  };

  system.stateVersion = "23.11";

  programs.firefox.enable = true;
  programs.steam.enable = true;

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
      };
    };
  };
}
