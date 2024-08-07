libfprint:

(final: prev:
{
  libfprint = prev.libfprint.overrideAttrs (old: {
    src = libfprint;
  });

  fprintd = prev.fprintd.overrideAttrs (old: {
    mesonCheckFlags = [
      "--no-suite"
      "fprintd:TestPamFprintd"
      "--no-suite"
      "fprintd:FPrintdManagerPreStartTests"
    ];
  });
})
