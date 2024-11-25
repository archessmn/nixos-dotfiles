let
  archessmn = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDcmDNjKEltZB9ZTijvfnka09iTJQ5Ro7QXBKhXpC4Ey archessmn@adrasteia";
  users = [ archessmn ];

  tsuro = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFJW1+M6OciB/nTfRTuTUUECmRqZ+J0deoMfNCfv0pRI";
  systems = [ tsuro ];
in
{
  "traefik_cloudflare.env.age".publicKeys = [ archessmn tsuro ];
  "traefik_kanidm.env.age".publicKeys = [ archessmn tsuro ];
  "vaultwarden.env.age".publicKeys = [ archessmn tsuro ];
}
