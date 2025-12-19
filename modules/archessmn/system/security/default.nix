{
  lib,
  isDarwin,
  ...
}:
with lib;
{
  imports = [
    ./agenix.nix
  ]
  ++ optionals (!isDarwin) [
    ./kanidm.nix
    ./ops.nix
    ./sudo.nix
    ./yubikey.nix
  ];
}
