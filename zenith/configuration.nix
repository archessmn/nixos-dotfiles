# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
# Just testing something

flake-overlays:

{ inputs, config, pkgs, username,
  hostname, gitUsername, theLocale,
  theTimezone, unstablePkgs, ... }:

let
  unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/master)
    # reuse the current configuration
    { config = config.nixpkgs.config; };
in

{
  imports =
    [
      ./hardware-configuration.nix
      # <home-manager/nixos>
      ../config/home/sunshine.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.overlays = [] ++ flake-overlays;

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

  networking.hostName = "zenith"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.networkmanager.enable = true;

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
    allowedTCPPorts = [ 47984 47989 47990 48010 ];
    allowedUDPPortRanges = [
      { from = 47998; to = 48000; }
      #{ from = 8000; to = 8010; }
    ];
  };

  services.tailscale.enable = true;

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

  # boot.initrd.kernelModules = [ "amdgpu" ];

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

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = [ pkgs.libvdpau-va-gl ];
  };

  environment.variables.VDPAU_DRIVER = "va_gl";
  environment.variables.LIBVA_DRIVER_NAME = "nvidia";
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Enable Docker
  virtualisation.docker.enable = true;

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "max" ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  users.users."${username}" = {
    isNormalUser = true;
    description = "${gitUsername}";
    extraGroups = [ "networkmanager" "wheel" "docker" "vboxusers" ];
    ignoreShellProgramCheck = true;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keyFiles = [ /home/max/.ssh/authorized_keys ];
  };

  nixpkgs.config.allowUnfree = true;
  
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  environment.systemPackages = with pkgs; [
    vim 
    wget
    curl
    libimobiledevice
    wineWowPackages.full
    openrgb

    sunshine

    # virtualbox
    # xilinx-ise
  ];

  services.udev.packages = with pkgs; [
    gnome.gnome-settings-daemon
    via
    moonlight-qt
    parsec-bin
    openrgb
    sunshine

    # virtualbox
    # xilinx-udev-rules
  ];

  programs.sunshine.enable = true;

  services.avahi.publish.enable = true;
  services.avahi.publish.userServices = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  system.stateVersion = "23.11";

  programs.firefox.enable = true;
  programs.steam.enable = true;

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    # displayManager.sddm.enable = true;
    # desktopManager.plasma5.enable = true;
  };

  hardware.nvidia = {

    modesetting.enable = true;

    powerManagement.enable = false;

    powerManagement.finegrained = false;

    open = false;

    nvidiaSettings = true;

    package = let 
      rcu_patch = pkgs.fetchpatch {
        url = "https://github.com/gentoo/gentoo/raw/c64caf53/x11-drivers/nvidia-drivers/files/nvidia-drivers-470.223.02-gpl-pfn_valid.patch";
        hash = "sha256-eZiQQp2S/asE7MfGvfe6dA/kdCvek9SYa/FFGp24dVg=";
      };
      in config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "535.154.05";
        sha256_64bit = "sha256-fpUGXKprgt6SYRDxSCemGXLrEsIA6GOinp+0eGbqqJg=";
        sha256_aarch64 = "sha256-G0/GiObf/BZMkzzET8HQjdIcvCSqB1uhsinro2HLK9k=";
        openSha256 = "sha256-wvRdHguGLxS0mR06P5Qi++pDJBCF8pJ8hr4T8O6TJIo=";
        settingsSha256 = "sha256-9wqoDEWY4I7weWW05F4igj1Gj9wjHsREFMztfEmqm10=";
        persistencedSha256 = "sha256-d0Q3Lk80JqkS1B54Mahu2yY/WocOqFFbZVBh+ToGhaE=";
        patches = [ rcu_patch ];
      };
  };

  programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.gnome.seahorse.out}/libexec/seahorse/ssh-askpass";

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

  services.usbmuxd.enable = true;

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
