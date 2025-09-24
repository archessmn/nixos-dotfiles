{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin-home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "unstable";
    };

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
      nix-darwin,
      home-manager,
      darwin-home-manager,
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
      username = "archessmn";
      flakeDir = "/home/archessmn/nixos-dotfiles/";

      stable-pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
        overlays = [
          (import ./config/libfprint.nix {
            inherit nixpkgs;
            inherit libfprint;
            system = system;
          })
          fsh.overlays.default
        ];
      };

      unstable-pkgs = import unstable {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };

      darwin-pkgs = import unstable {
        system = "aarch64-darwin";
        config = {
          allowUnfree = true;
        };
        overlays = [
          fsh.overlays.default
        ];
      };

      sharedArgs = {
        inherit inputs;
        inherit username;
        inherit fsh;
        inherit flakeDir;
        inherit agenix;
      };

      linuxArgs = {
        inherit stable-pkgs;
        inherit unstable-pkgs;
      };

      darwinArgs = {
        inherit darwin-pkgs;
        flakeDir = "/Users/archessmn/nixos-dotfiles/";
      };

      commonModules = [
        ./modules/archessmn
        home-manager.nixosModules.home-manager
        inputs.minegrub-theme.nixosModules.default
        agenix.nixosModules.default
      ];

      hosts = import ./hosts;

      linuxHosts = nixpkgs.lib.filterAttrs (_: host: host.system == "x86_64-linux") hosts;
      darwinHosts = nixpkgs.lib.filterAttrs (_: host: host.system == "aarch64-darwin") hosts;
    in
    rec {
      # darwinConfigurations."helios" = nix-darwin.lib.darwinSystem {
      #   specialArgs = sharedArgs;
      #   modules = [
      #     darwin-home-manager.darwinModules.home-manager
      #     ./hosts/helios/configuration.nix
      #     {
      #       nixpkgs.pkgs = darwin-pkgs;
      #     }
      #   ];
      # };

      darwinConfigurations = mapAttrs (
        hostname: host:
        nix-darwin.lib.darwinSystem {
          specialArgs = sharedArgs // darwinArgs // { system = host.system; };
          modules = [
            darwin-home-manager.darwinModules.home-manager
            ./hosts/${hostname}/configuration.nix
            agenix.nixosModules.default
            {
              nixpkgs.pkgs = darwin-pkgs;
            }
          ];
        }
      ) darwinHosts;

      nixosConfigurations =
        mapAttrs (
          hostname: host:
          nixosSystem {
            specialArgs = sharedArgs // linuxArgs // { system = host.system; };
            modules = [
              ./hosts/${hostname}/configuration.nix
              ./modules/archessmn
              home-manager.nixosModules.home-manager
              inputs.minegrub-theme.nixosModules.default
              agenix.nixosModules.default
              {
                nixpkgs.pkgs = stable-pkgs;
              }
            ];
          }
        ) linuxHosts
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
