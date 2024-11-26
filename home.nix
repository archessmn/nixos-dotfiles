{ config
, lib
, pkgs
, unstablePkgs
, inputs
, username
, gitUsername
, gitEmail
, browser
, flakeDir
, fsh
, ...
}:

let
  inherit (lib) concatMapStrings getAttr attrNames;

  keys = import ./config/ssh/keys.nix;
  user = (import ./users.nix).${username};
in
{
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "23.11";

  imports = [
    # fsh.homeModules.fsh
    ./config/home/dconf.nix
    ./config/home/kanidm.nix
    ./config/home/kitty.nix
    ./config/home/neovim.nix
    ./config/home/rio.nix
    ./config/home/shell
    ./config/home/vscode.nix
  ];

  fonts.fontconfig.enable = true;

  home.packages = [
    # Programming things
    pkgs.rustc
    pkgs.cargo
    pkgs.nodejs
    pkgs.nodePackages.npm
    pkgs.bun
    # pkgs.gccgo13
    pkgs.jetbrains.idea-ultimate
    # pkgs.jdk8
    # pkgs.jdk11
    # pkgs.jdk17
    pkgs.jdk21
    pkgs.jflap

    unstablePkgs.zed-editor

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
    pkgs.htop
    pkgs.btop
    pkgs.sl

    # Communications
    pkgs.slack
    pkgs.discord
    pkgs.element-desktop
    pkgs.whatsapp-for-linux

    # Security stuff
    unstablePkgs.kanidm
    pkgs.bitwarden

    # Desktop stuff
    pkgs.anytype
    pkgs.spotify
    pkgs.via
    pkgs.obsidian
    pkgs.x32edit

    # pkgs.dropbox
    pkgs.vlc
    pkgs.helvum
    pkgs.gnomeExtensions.appindicator
    pkgs.gnomeExtensions.topicons-plus
    pkgs.gnomeExtensions.blur-my-shell
    pkgs.gnomeExtensions.color-picker
    pkgs.gnomeExtensions.media-controls
    pkgs.gnomeExtensions.vitals
    pkgs.gnomeExtensions.gsconnect
    pkgs.gnomeExtensions.quick-settings-tweaker

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

  home.file.".ssh/allowed_signers".text = concatMapStrings (key: "${user.email} ${key}\n") (map (key: getAttr key keys) (attrNames keys));

  programs.git = {
    enable = true;

    userEmail = user.email;
    userName = user.fullName;

    extraConfig = {
      commit.gpgsign = true;
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      user.signingkey = "~/.ssh/id_ed25519";
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true; # see note on other shells below
    nix-direnv.enable = true;
  };

  home.file.".config/pylint".source = ./config/pylint;
  home.file.".config/pylint".recursive = true;
}
