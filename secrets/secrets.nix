let
  archessmn-adrasteia = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDcmDNjKEltZB9ZTijvfnka09iTJQ5Ro7QXBKhXpC4Ey archessmn@adrasteia";
  archessmn-zenith = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICFI0pAOSkn/deHOz31uavaCWQ770w9Bxv3MVC9Jsts3 archessmn@zenith";
  users = [ archessmn-adrasteia archessmn-zenith ];

  tsuro = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFJW1+M6OciB/nTfRTuTUUECmRqZ+J0deoMfNCfv0pRI";
  systems = [ tsuro ];
in
{
  "traefik_cloudflare.env.age".publicKeys = [ archessmn-adrasteia archessmn-zenith tsuro ];
  "traefik_kanidm.env.age".publicKeys = [ archessmn-adrasteia archessmn-zenith tsuro ];
  "vaultwarden.env.age".publicKeys = [ archessmn-adrasteia archessmn-zenith tsuro ];
}
