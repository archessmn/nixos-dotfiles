{ config, pkgs, unstablePkgs, inputs, username,
  gitUsername, gitEmail,
  browser, flakeDir, ... }:

{
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "23.11";

  imports = [
    ./config/home/dconf.nix
    ./config/home/kanidm.nix
    ./config/home/kitty.nix
    ./config/home/neovim.nix
    ./config/home/rio.nix
    ./config/home/vscode.nix
    ./config/home/zsh.nix
  ];

  fonts.fontconfig.enable = true;

  home.packages = [
    # Programming things
    pkgs.rustc
    pkgs.cargo
    pkgs.nodejs
    pkgs.nodePackages.npm
    pkgs.bun
    pkgs.gccgo13
    pkgs.jetbrains.idea-ultimate
    # pkgs.jdk8
    # pkgs.jdk11
    # pkgs.jdk17
    pkgs.jdk21
    pkgs.jflap

    pkgs.zed-editor

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

  home.file.".ssh/allowed_signers".text = 
    "${gitEmail} ${builtins.readFile /home/${username}/.ssh/id_ed25519.pub}";

  programs.git = {
    enable = true;

    userEmail = gitEmail;
    userName  = gitUsername;

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
