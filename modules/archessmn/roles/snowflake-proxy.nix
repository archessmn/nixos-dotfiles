{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.archessmn.roles.snowflake-proxy;
in
{
  options.archessmn.roles.snowflake-proxy = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      backend = "docker";

      containers = {
        snowflake-proxy = {
          image = "containers.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake:latest";
          autoStart = true;

          extraOptions = [
            "--network=host"
          ];
        };

        snowflake-proxy-watchtower = {
          image = "containrrr/watchtower";
          autoStart = true;

          volumes = [
            "/var/run/docker.sock:/var/run/docker.sock"
          ];

          command = [
            "snowflake-proxy"
          ];
        };
      };
    };

  };
}
