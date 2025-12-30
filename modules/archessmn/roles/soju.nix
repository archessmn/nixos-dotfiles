{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.soju;
  tls-dir = config.security.acme.certs."${config.networking.hostName}.infra.archess.mn".directory;
in
{
  options.archessmn.roles.soju = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    security.acme.certs."${config.networking.hostName}.infra.archess.mn".reloadServices = [
      "soju.service"
    ];

    services.soju = {
      enable = true;
      # listen only over tailscale
      listen = [
        "ircs://0.0.0.0"
      ];
      hostName = "${config.networking.hostName}.infra.archess.mn";
      adminSocket.enable = true;
      # we store in the db
      enableMessageLogging = false;
      extraConfig = ''
        message-store db
      '';
      tlsCertificate = "${tls-dir}/fullchain.pem";
      tlsCertificateKey = "${tls-dir}/key.pem";
    };

    systemd.services.soju.serviceConfig.SupplementaryGroups = "acme";

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ 6697 ];
  };
}
