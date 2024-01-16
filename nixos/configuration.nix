# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
# Just testing something

{ config, pkgs, ... }:

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
      <home-manager/nixos>
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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

  networking.hostName = "pavilion-nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  console.keyMap = "uk";

  boot.initrd.kernelModules = [ "amdgpu" ];

  hardware.opengl.driSupport = true;

  # Enable Docker
  virtualisation.docker.enable = true;

  users.users.max = {
    isNormalUser = true;
    description = "Max Moir";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    ignoreShellProgramCheck = true;
    shell = pkgs.zsh;
  };

  nixpkgs.config.allowUnfree = true;
  
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.max = { pkgs, ... }: {
    # environment.variable.EDITOR = "nvim";
    fonts.fontconfig.enable = true;
    home.packages = [
      # Programming things
      pkgs.rustc
      pkgs.cargo
      pkgs.gccgo13

      # Terminal shit
      pkgs.git
      pkgs.gh
      pkgs.vimPlugins.nvim-treesitter
      pkgs.vimPlugins.nvim-treesitter-parsers.nix
      pkgs.kitty
      pkgs.rio
      pkgs.walk
      pkgs.bat
      pkgs.neofetch
      pkgs.fzf

      # Communications
      pkgs.slack
      pkgs.discord
      pkgs.element-desktop
      pkgs.whatsapp-for-linux

      # Desktop stuff
      pkgs.anytype
      pkgs.spotify
      pkgs.via
      pkgs.obsidian
      pkgs.bitwarden
      pkgs.dropbox
      pkgs.vlc
      pkgs.gnomeExtensions.appindicator
      pkgs.gnomeExtensions.topicons-plus
      # with pkgs.gnomeExtensions; [
      #   appindicator
      #   topicons-plus
      # ];

      # Gaming
      pkgs.lutris
      pkgs.steam
      pkgs.thunderbird
      pkgs.prismlauncher

      # Remote stuff
      pkgs.moonlight-qt
      pkgs.parsec-bin
      pkgs.virt-viewer
      pkgs.termius

      # Fonts
      (pkgs.nerdfonts.override { fonts = [ "FiraMono" ]; })
    ];
    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };
    programs.vscode = {
      enable = true;
      package = pkgs.vscode.fhsWithPackages (ps: with ps; [ 
        rustup
        rustc
        cargo
        cargo-generate
        cargo-watch
        cargo-nextest
        cargo-flamegraph
        zlib
        openssl.dev
        pkg-config
        gccgo13
        cmake
        gdb
        git
        just
        python3
        nodejs
      ]);
    };
    programs.eza = {
      enable = true;
      enableAliases = true;
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
      icons = true;
    };
    programs.zsh = {
      enable = true;
      dotDir = ".config/zsh";
      shellAliases = {
        cat = "bat";
	nixconfig = "export EDITOR=nvim && sudoedit /etc/nixos/configuration.nix";
	rebuild = "sudo nixos-rebuild switch";
      };
      enableVteIntegration = true;
      oh-my-zsh = {
        enable = true;
	plugins = [
	  "genpass"
        ];
	theme = "robbyrussell";
      };
    };
    programs.kitty = {
      enable = true;
      font.package = (pkgs.nerdfonts.override { fonts = [ "FiraMono" ]; });
      font.name = "FiraMono Nerd Font";
    };
    programs.rio = {
      enable = true;
    };

    home.file.".config/nvim".source = "/home/max/nixos-dotfiles/.config/nvim";
    home.file.".config/nvim".recursive = true;
 
    home.file.".config/pylint".source = "/home/max/nixos-dotfiles/.config/pylint";
    home.file.".config/pylint".recursive = true;

    home.stateVersion = "23.05";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim 
    wget
    # gnomeExtensions.appindicator
    # gnomeExtensions.topicons-plus
  ];

  services.udev.packages = with pkgs; [
    gnome.gnome-settings-daemon
    via
    moonlight-qt
    parsec-bin
  ];

  # services.openssh.enable = true;

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

  system.stateVersion = "23.05";

  programs.firefox.enable = true;
  programs.steam.enable = true;

  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
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
