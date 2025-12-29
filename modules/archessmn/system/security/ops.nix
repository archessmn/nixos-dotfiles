{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.archessmn;
in
{
  options.archessmn.system.security = {
    opsUser = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.system.security.opsUser {

    nix.settings.trusted-users = [
      "@wheel"
      "ops"
    ];

    users.users.ops = {
      isNormalUser = true;
      description = "OPS";
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
      ];
      hashedPassword = "$y$j9T$1Knq0KkjTsgJSaXSoVib31$iQEJC4/gr1dCKz9tYGp7jyGxV9Op9gFsUJ.ZaNvVYLC";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKGslDZkmwJa0h8LC8v8A+XRRcwK3MqY72pFUQqeHAXX archessmn@ops-user"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPcXDExjR2UOfcmas0AM6l0c+jW/yq7ViIyPu3/nyC8l jenkins@temjin"
      ];
      packages = with pkgs; [ jdk21 ];
    };

    security.sudo.extraRules = [
      {
        users = [ "ops" ];
        runAs = "ALL:ALL";
        commands = [
          {
            command = "ALL";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];

  };
}
