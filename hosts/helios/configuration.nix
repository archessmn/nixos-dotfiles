{
  pkgs,
  fsh,
  username,
  ...
}:
let
  user = (import ../../users.nix).${username};
in
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking.hostName = "helios";
  networking.localHostName = "helios";

  programs.fish.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  services.tailscale = {
    enable = true;
  };

  users.users.${username} = {
    home = "/Users/${username}";

    shell = pkgs.fish;
    ignoreShellProgramCheck = true;
  };

  home-manager.useGlobalPkgs = true;

  home-manager.backupFileExtension = "backup";

  home-manager.users.${username} =
    { pkgs, ... }:
    {
      imports = [ fsh.homeModules.fsh ];

      home.packages = with pkgs; [
        atuin
        nixfmt
        kitty
        kanidm
        obsidian
        tailscale
      ];

      programs.fish.enable = true;

      programs.fsh.enable = true;

      programs.atuin = {
        enable = true;
        settings = {
          auto_sync = true;
          sync_frequency = "1m";
          sync_address = "https://atuin.archess.mn";
          ctrl_n_shortcuts = true;
          style = "auto";
        };
        enableZshIntegration = true;
        enableFishIntegration = true;
      };

      programs.git = {
        enable = true;

        userEmail = user.email;
        userName = user.fullName;

        extraConfig = {
          init.defaultBranch = "main";
          push.autoSetupRemote = "true";
          pull.rebase = true;
          commit.gpgsign = true;
          gpg.format = "ssh";
          gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
          user.signingkey = "~/.ssh/id_ed25519";
        };
      };

      programs.helix = {
        enable = true;
        defaultEditor = true;
      };

      home.stateVersion = "25.05";
    };

  system.stateVersion = 6;
}
