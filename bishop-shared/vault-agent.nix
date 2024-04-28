{ config, lib, pkgs, ... }:

{
  # environment.variables.VAULT_ADDR = "http://localhost:8200";
  #services.vault-agent.instances.bishop = {
  #  enable = true;
  #  user = "root";
  #  settings = {
  #    vault = {
  #      address = "http://localhost:8200";
  #    };
  #    template = [
  #      "{{ with secret \"cubbyhole/test\"}}"
  #      "{{ .Data.foo }}"
  #      "{{ end }}"
  #    ];
  #  };
  #};
}
