{ config, pkgs, unstablePkgs, ... }:

{
  environment.variables.VAULT_ADDR = "http://localhost:8200";
  services.vault = {
    enable = true;
    package = unstablePkgs.vault-bin;
    address = "0.0.0.0:8200";
    # tlsKeyFile = "/var/lib/vault/.ssl/vault_key.pem";
    # tlsCertFile = "/var/lib/vault/.ssl/vault_crt.pem";
    extraConfig = ''
      ui = true
      disable_mlock = true
    '';
    # seal "transit" {
    #   address = "http://active.vault.service.consul:8200"
    #   disable_renewal = "false"
    #   key_name = "autounseal"
    #   mount_path = "transit/"
    # }

    extraSettingsPaths = [
      /run/secrets/vault.hcl
    ];
    storageBackend = "consul";
    storageConfig = ''
      address = "127.0.0.1:8500"
      path    = "vault/"
    '';
    #listenerExtraConfig = ''
    #  tls_disable = true
    #'';
  };
}
