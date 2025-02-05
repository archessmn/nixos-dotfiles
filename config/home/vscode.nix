{ config
, pkgs
, inputs
, username
, gitUsername
, gitEmail
, browser
, flakeDir
, ...
}:
{
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

}
