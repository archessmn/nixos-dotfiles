{ config, pkgs, inputs, username,
  gitUsername, gitEmail,
  browser, flakeDir, ... }:

{
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "23.11";

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

  home.file.".config/nvim".source = ./.config/nvim;
  home.file.".config/nvim".recursive = true;

  home.file.".config/pylint".source = ./.config/pylint;
  home.file.".config/pylint".recursive = true;
}
