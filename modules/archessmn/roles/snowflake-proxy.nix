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
          image = "docker.io/containrrr/watchtower:latest@sha256:f9086bfda061100361fc2bacf069585678d760d705cf390918ccdbda8a00980b";
          autoStart = true;

          volumes = [
            "/var/run/docker.sock:/var/run/docker.sock"
          ];

          cmd = [
            "snowflake-proxy"
          ];
        };
      };
    };

  };
}
