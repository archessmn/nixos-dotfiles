{ config, pkgs, ... }:

{
  services.consul-template.instances.main = {
    enable = true;
    settings = {
      consul = {
        address = "http://consul.service.consul:8500";
      };

      # log_level = "debug";

      vault = {
        address = "http://active.vault.service.consul:8200";
      };

      template = [
        {
          source = "/home/max/test.template";
          destination = "/home/max/test.rendered";
        }
      ];
    };
  };
}
