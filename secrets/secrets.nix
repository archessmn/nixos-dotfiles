let
  archessmn-adrasteia = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDcmDNjKEltZB9ZTijvfnka09iTJQ5Ro7QXBKhXpC4Ey archessmn@adrasteia";
  archessmn-helios = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAKbv0CfhD/1mE+OORtFtHcj9PA3Gal6S/+czXp82B0t archessmn@helios";
  archessmn-temjin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMh2mUHL7drQsnB/3q4PDBD6XoQTB6OOr5bXXvqwlxYa archessmn@temjin";
  archessmn-zenith = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICFI0pAOSkn/deHOz31uavaCWQ770w9Bxv3MVC9Jsts3 archessmn@zenith";
  users = [
    archessmn-adrasteia
    archessmn-helios
    archessmn-temjin
    archessmn-zenith
  ];

  temjin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA3TSB/Hx9BYN+UeGpVXQFtetVyuZ72MNcg0ADHGrxNP";
  tsuro = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFJW1+M6OciB/nTfRTuTUUECmRqZ+J0deoMfNCfv0pRI";
  systems = [ temjin tsuro ];
in
{
  "traefik_cloudflare.env.age".publicKeys = [
    archessmn-adrasteia
    archessmn-zenith
    tsuro
  ];
  "traefik_kanidm.env.age".publicKeys = [
    archessmn-adrasteia
    archessmn-zenith
    tsuro
  ];
  "vaultwarden.env.age".publicKeys = [
    archessmn-adrasteia
    archessmn-zenith
    tsuro
  ];
  "keycloak_postgres_password.age".publicKeys = [
    archessmn-adrasteia
    archessmn-zenith
    tsuro
  ];

  "temjin_traefik_cloudflare.env.age".publicKeys = [
    archessmn-helios
    archessmn-temjin
    temjin
  ];

  "temjin_traefik_kanidm.env.age".publicKeys = [
    archessmn-helios
    archessmn-temjin
    temjin
  ];
}
