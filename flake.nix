{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # nix-fpga-tools = {
    #   url = "github:archessmn/nix-fpga-tools";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = inputs@{ nixpkgs, unstable, home-manager, ... }:
  let
    system = "x86_64-linux";

    # User Variables
    hostname = "archessmn-default";
    username = "max";
    gitUsername = "Mia Moir";
    gitEmail = "me@archess.mn";
    theLocale = "en_GB.UTF-8";
    theTimezone = "Europe/London";
    browser = "firefox";
    flakeDir = "/home/max/nixos-dotfiles/";

    pkgs = import nixpkgs {
      inherit system;
      config = {
	      allowUnfree = true;
      };
      overlays = [
        (final: prev:
          {
            libfprint = prev.libfprint.overrideAttrs (old: {
              src = builtins.fetchGit {
                url = "https://gitlab.freedesktop.org/depau/libfprint.git";
                ref = "elanmoc2";
                # rev = "f4439ce96b2938fea8d4f42223d7faea05bd4048";
              };
            });

            fprintd = prev.fprintd.overrideAttrs (old: {
              mesonCheckFlags = [
                # PAM related checks are timing out
                "--no-suite" "fprintd:TestPamFprintd" 
                # Tests FPrintdManagerPreStartTests.test_manager_get_no_default_device & FPrintdManagerPreStartTests.test_manager_get_no_devices are failing
                "--no-suite" "fprintd:FPrintdManagerPreStartTests"
              ];
            });
          })
      ];
    };

    unstablePkgs = import unstable {
      inherit system;
      config ={
        allowUnfree = true;
      };
    };

    flake-overlays = [
      # nix-fpga-tools.overlay
    ];
  in {
    nixosConfigurations = {
      adrasteia = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit pkgs; inherit system; inherit inputs; 
          inherit username; inherit hostname; inherit gitUsername;
          inherit gitEmail; inherit theLocale; inherit theTimezone;
          inherit unstablePkgs;
        };
        modules = [ (import ./hosts/adrasteia/configuration.nix flake-overlays)
          home-manager.nixosModules.home-manager {
            home-manager.extraSpecialArgs = { inherit username; 
              inherit gitUsername; inherit gitEmail; inherit inputs;
              inherit browser; inherit flakeDir; inherit unstablePkgs;
            };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./home.nix;
          }
        ];
      };
    
      honkpad = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit system; inherit inputs; 
          inherit username; inherit hostname; inherit gitUsername;
          inherit gitEmail; inherit theLocale; inherit theTimezone;
          inherit unstablePkgs;
        };
        modules = [ ./hosts/honkpad/configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.extraSpecialArgs = { inherit username; 
              inherit gitUsername; inherit gitEmail; inherit inputs;
              inherit browser; inherit flakeDir; inherit unstablePkgs;
            };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./home.nix;
          }
	];
      };      

      zenith = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit system; inherit inputs; 
          inherit username; inherit hostname; inherit gitUsername;
          inherit gitEmail; inherit theLocale; inherit theTimezone;
          inherit unstablePkgs;
        };
        modules = [ (import ./zenith/configuration.nix flake-overlays)
          home-manager.nixosModules.home-manager {
            home-manager.extraSpecialArgs = { inherit username; 
              inherit gitUsername; inherit gitEmail; inherit inputs;
              inherit browser; inherit flakeDir; inherit unstablePkgs;
            };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./home.nix;
          }
        ];
      };

      slowpoke = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit system; inherit inputs; 
          inherit username; inherit hostname; inherit gitUsername;
          inherit gitEmail; inherit theLocale; inherit theTimezone;
        };
	modules = [ ./slowpoke/configuration.nix
          home-manager.nixosModules.home-manager {
          home-manager.extraSpecialArgs = { inherit username; 
            inherit gitUsername; inherit gitEmail; inherit inputs;
            inherit browser; inherit flakeDir;
          };
          home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./home.nix;
          }
	];
      };

      godshawke = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit system; inherit inputs; 
           inherit hostname; inherit gitUsername; username = "archessmn";
          inherit gitEmail; inherit theLocale; inherit theTimezone;
          inherit unstablePkgs;
        };
	      modules = [ (import ./hosts/godshawke/configuration.nix flake-overlays)
          home-manager.nixosModules.home-manager {
            home-manager.extraSpecialArgs = { username = "archessmn";
              inherit gitUsername; inherit gitEmail; inherit inputs;
              inherit browser; inherit flakeDir; inherit unstablePkgs;
            };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."archessmn" = import ./home.nix;
          }
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
