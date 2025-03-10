{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    libfprint = {
      url = "git+https://gitlab.freedesktop.org/depau/libfprint?ref=elanmoc2";
      flake = false;
    };

    fsh = {
      url = "github:archessmn/fsh?ref=shell-levels";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    minegrub-theme.url = "github:Lxtharia/minegrub-theme";
  };

  outputs =
    inputs@{
      nixpkgs,
      unstable,
      home-manager,
      libfprint,
      fsh,
      minegrub-theme,
      agenix,
      ...
    }:
    let
      inherit (nixpkgs.lib) nixosSystem mapAttrs;

      system = "x86_64-linux";

      # User Variables
      hostname = "archessmn-default";
      username = "archessmn";
      gitUsername = "Mia Moir";
      gitEmail = "me@archess.mn";
      theLocale = "en_GB.UTF-8";
      theTimezone = "Europe/London";
      browser = "firefox";
      flakeDir = "/home/archessmn/nixos-dotfiles/";

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
        overlays = [
          (import ./config/libfprint.nix libfprint)
          fsh.overlays.default
        ];
      };

      unstable-pkgs = import unstable {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };

      flake-overlays = [ ];

      sharedArgs = {
        inherit pkgs;
        inherit system;
        inherit inputs;
        inherit username;
        inherit unstable-pkgs;
        inherit fsh;
        inherit flakeDir;
        inherit agenix;
      };

      commonModules = [
        ./modules/archessmn
        home-manager.nixosModules.home-manager
        inputs.minegrub-theme.nixosModules.default
        agenix.nixosModules.default
      ];
    in
    rec {
      nixosConfigurations =
        (mapAttrs (
          hostname: host:
          nixosSystem {
            specialArgs = sharedArgs;
            modules = [
              ./hosts/${hostname}/configuration.nix
              ./modules/archessmn
              home-manager.nixosModules.home-manager
              inputs.minegrub-theme.nixosModules.default
              agenix.nixosModules.default
            ];
          }
        ) (import ./hosts))
        // ({
          exampleIso = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
              (
                { pkgs, ... }:
                {
                  environment.systemPackages = [ pkgs.vim ];
                }
              )
              ./iso/configuration.nix
            ];
          };
        });
    };
}
