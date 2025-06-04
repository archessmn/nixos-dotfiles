{
  nixpkgs,
  libfprint,
  system,
}:

let
  pkgs = import nixpkgs {
    inherit system;
  };

  fprintd-version = "1.94.4";
in
(final: prev: {
  libfprint = prev.libfprint.overrideAttrs (old: {
    src = libfprint;
    buildInputs = old.buildInputs ++ [ pkgs.nss ];
    # buildInputs = old.buildInputs;
  });

  fprintd = prev.fprintd.overrideAttrs (old: {
    version = fprintd-version;

    src = pkgs.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "libfprint";
      repo = "fprintd";
      rev = "refs/tags/v${fprintd-version}";
      hash = "sha256-B2g2d29jSER30OUqCkdk3+Hv5T3DA4SUKoyiqHb8FeU=";
    };

    mesonCheckFlags = [
      "--no-suite"
      "fprintd:TestPamFprintd"
      "--no-suite"
      "fprintd:FPrintdManagerPreStartTests"
    ];
  });
})
