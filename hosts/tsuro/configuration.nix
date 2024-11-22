{ inputs
, config
, lib
, pkgs
, username
, unstablePkgs
, ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  archessmn = {
    desktop = {
      enable = false;
    };

    system = {
      bootloader = "hardware-defined";
      docker = true;
    };

    roles = {
      traefik.enable = true;
    };
  };


  # Include Agenix Secrets
  age.secrets.traefik_cloudflare_env.file = ../../secrets/traefik_cloudflare.env.age;
  age.secrets.traefik_kanidm_env.file = ../../secrets/traefik_kanidm.env.age;


  networking.hostName = "tsuro";

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  # networking.domain = "";
  # services.openssh.enable = true;
  # users.users.root.openssh.authorizedKeys.keys = [ ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID7Oux90eiurP5T1vQ9PF6ibIxxzAQBrPB8ZWnuk0Vvb'' ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG0HpThCYE2gOZvrU8sRFqeOKS4llKMzALqx5+T+zxpV'' ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDcmDNjKEltZB9ZTijvfnka09iTJQ5Ro7QXBKhXpC4Ey'' ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMh2mUHL7drQsnB/3q4PDBD6XoQTB6OOr5bXXvqwlxYa'' ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICFI0pAOSkn/deHOz31uavaCWQ770w9Bxv3MVC9Jsts3'' ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICR2wCQqZvFKmKByOGBAAjv4EdsFXvxzbVx0a15EjBpz'' ''sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBB252zkVQgeI4NPUSqt0UzIxicmUspZr2SzPeb18IktFzeqsL/X6+g8AF4lBymuuiJPpMVMmDR9ux10YgW41HFMAAAAEc3NoOg=='' ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBjm5bvRdZcofeBZ/lhke5hIKRAyejACr3tw7LQJUfl7'' ];
  system.stateVersion = "23.11";
}
