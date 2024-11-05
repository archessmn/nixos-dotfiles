{ lib, config, pkgs, unstablePkgs, username, ... }:
with lib;
let
  desktopEnabled = config.archessmn.desktop.enable;
  cfg = config.archessmn.home.home-manager.desktop.vscode;
in

{
  options.archessmn.home.home-manager.desktop.vscode = {
    enable = mkOption {
      type = types.bool;
      default = desktopEnabled;
    };
  };

  config.home-manager.users.${username} = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscode.fhsWithPackages (ps: with ps; [
        rustup
        rustc
        cargo
        rust-analyzer
        cargo-generate
        cargo-watch
        cargo-nextest
        cargo-flamegraph
        zlib
        openssl.dev
        pkg-config
        # gccgo13
        cmake
        gdb
        git
        just
        python3
        nodejs
        nodePackages.npm
        nixd
        nixpkgs-fmt

        # jdk8
        jdk11
        jdk17
      ]);
    };

  };
}
