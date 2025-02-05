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

      unstablePkgs = import unstable {
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
        inherit unstablePkgs;
        inherit fsh;
        inherit flakeDir;
        inherit agenix;
      };
    in
    {
      nixosConfigurations = {
        adrasteia = nixpkgs.lib.nixosSystem {
          specialArgs = sharedArgs;
          modules = [
            ./hosts/adrasteia/configuration.nix
            ./modules/archessmn
            home-manager.nixosModules.home-manager
            inputs.minegrub-theme.nixosModules.default
          ];
        };

        honkpad = nixpkgs.lib.nixosSystem {
          specialArgs = sharedArgs;
          modules = [
            ./hosts/honkpad/configuration.nix
            ./modules/archessmn
            home-manager.nixosModules.home-manager
            inputs.minegrub-theme.nixosModules.default
          ];
        };

        zenith = nixpkgs.lib.nixosSystem {
          specialArgs = sharedArgs;
          modules = [
            ./hosts/zenith/configuration.nix
            ./modules/archessmn
            home-manager.nixosModules.home-manager
            inputs.minegrub-theme.nixosModules.default
          ];
        };

        av-imposter = nixpkgs.lib.nixosSystem {
          specialArgs = sharedArgs;
          modules = [
            ./hosts/av-imposter/configuration.nix
            ./modules/archessmn
            home-manager.nixosModules.home-manager
            inputs.minegrub-theme.nixosModules.default
          ];
        };

        nostromo = nixpkgs.lib.nixosSystem {
          specialArgs = sharedArgs;
          modules = [
            ./hosts/nostromo/configuration.nix
            ./modules/archessmn
            home-manager.nixosModules.home-manager
            inputs.minegrub-theme.nixosModules.default
          ];
        };

        tsuro = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = sharedArgs;
          modules = [
            ./hosts/tsuro/configuration.nix
            ./modules/archessmn
            home-manager.nixosModules.home-manager
            inputs.minegrub-theme.nixosModules.default
            agenix.nixosModules.default
          ];
        };

        # Needs moving to new username
        slowpoke = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit system;
            inherit inputs;
            inherit hostname;
            inherit gitUsername;
            inherit gitEmail;
            inherit theLocale;
            inherit theTimezone;
          };
          modules = [
            ./slowpoke/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                inherit gitUsername;
                inherit gitEmail;
                inherit inputs;
                inherit browser;
                inherit flakeDir;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            }
          ];
        };

        godshawke = nixpkgs.lib.nixosSystem {
          specialArgs = sharedArgs;
          modules = [
            ./hosts/godshawke/configuration.nix
            ./modules/archessmn
            ./roles/family-pc.nix
            home-manager.nixosModules.home-manager
            inputs.minegrub-theme.nixosModules.default
          ];
        };

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

        # TODO: Have a look at implementing a similar script to below
        # https://discourse.nixos.org/t/deploy-nixos-configurations-on-other-machines/22940/6
        nixos-103-bishop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nixos-103-bishop/configuration.nix
          ];
        };

        nixos-104-bishop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nixos-104-bishop/configuration.nix
          ];
        };

        nixos-105-bishop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nixos-105-bishop/configuration.nix
          ];
        };

        nixos-200-bishop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nixos-200-bishop/configuration.nix
          ];
        };
      };
    };
}
