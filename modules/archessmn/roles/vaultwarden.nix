{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.vaultwarden;
in
{
  options.archessmn.roles.vaultwarden = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {

    systemd.tmpfiles.rules = [
      "d /opt/vaultwarden 1766 root root"
    ];

    virtualisation.oci-containers.backend = "docker";

    virtualisation.oci-containers.containers.vaultwarden = {
      autoStart = true;

      image = "vaultwarden/server:1.35.1";

      ports = [
        "7003:80"
      ];

      volumes = [
        "/opt/vaultwarden:/data"
      ];

      environmentFiles = [
        config.age.secrets.vaultwarden_env.path
      ];

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.vaultwarden.rule" = "Host(`vault.moir.xyz`)";
      };
    };
  };
}
