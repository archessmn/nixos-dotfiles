{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    libfprint = {
      url = "git+https://gitlab.freedesktop.org/depau/libfprint?ref=elanmoc2";
      flake = false;
    };

    fsh = {
      url = "github:ashhhleyyy/fsh";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, unstable, home-manager, libfprint, fsh, ... }:
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
    in
    {
      nixosConfigurations = {
        adrasteia = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit pkgs; inherit system; inherit inputs;
            inherit username; inherit unstablePkgs;
          };
          modules = [
            ./hosts/adrasteia/configuration.nix
            ./modules/archessmn
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                inherit pkgs;
                inherit username;
                inherit inputs;
                inherit unstablePkgs;
                inherit fsh;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${username} = import ./home.nix;
            }
          ];
        };

        honkpad = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit system; inherit inputs;
            username = "max"; inherit hostname; inherit gitUsername;
            inherit gitEmail; inherit theLocale; inherit theTimezone;
            inherit unstablePkgs;
          };
          modules = [
            ./hosts/honkpad/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                username = "max";
                inherit gitUsername; inherit gitEmail; inherit inputs;
                inherit browser; inherit flakeDir; inherit unstablePkgs;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users."max" = import ./home.nix;
            }
          ];
        };

        zenith = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit system; inherit inputs;
            username = "max"; inherit hostname; inherit gitUsername;
            inherit gitEmail; inherit theLocale; inherit theTimezone;
            inherit unstablePkgs;
          };
          modules = [
            (import ./zenith/configuration.nix flake-overlays)
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                username = "max";
                inherit gitUsername; inherit gitEmail; inherit inputs;
                inherit browser; inherit flakeDir; inherit unstablePkgs;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users."max" = import ./home.nix;
            }
          ];
        };

        slowpoke = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit system; inherit inputs;
            username = "max"; inherit hostname; inherit gitUsername;
            inherit gitEmail; inherit theLocale; inherit theTimezone;
          };
          modules = [
            ./slowpoke/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                username = "max";
                inherit gitUsername; inherit gitEmail; inherit inputs;
                inherit browser; inherit flakeDir;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users."max" = import ./home.nix;
            }
          ];
        };

        godshawke = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit pkgs;
            inherit system;
            inherit inputs;
            inherit username;
            inherit unstablePkgs;
            inherit fsh;
          };
          modules = [
            ./hosts/godshawke/configuration.nix
            ./modules/archessmn
            home-manager.nixosModules.home-manager
          ];
        };


        exampleIso = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            ({ pkgs, ... }: {
              environment.systemPackages = [ pkgs.vim ];
            })
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
