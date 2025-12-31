{
  username,
  ...
}:
{
  archessmn = {
    home = {
      home-manager = {
        desktop.git.enable = true;
        desktop.senpai.enable = true;
        stateVersion = "25.05";
      };
    };
    system.security.agenix.enable = true;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking.hostName = "helios";
  networking.localHostName = "helios";

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  services.tailscale = {
    enable = true;
  };

  services.openssh = {
    enable = true;
    extraConfig = ''
      PermitRootLogin no
      PasswordAuthentication no
      PermitEmptyPasswords no
      KbdInteractiveAuthentication no
    '';
  };

  home-manager.useGlobalPkgs = true;

  home-manager.backupFileExtension = "backup";

  home-manager.users.${username} =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        nixfmt
        nil
        kanidm_1_8
        tailscale
      ];
    };

  system.stateVersion = 6;
}
