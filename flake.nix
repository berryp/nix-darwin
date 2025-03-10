{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    # Utility for watching macOS `defaults`.
    # prefmanager = {
    #   url = "github:malob/prefmanager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   # inputs.flake-compat.follows = "flake-compat";
    #   # inputs.flake-utils.follows = "flake-utils";
    # };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    darwin,
    nixos-generators,
    ...
  } @ inputs: let
    inherit
      (self.lib)
      attrValues
      makeOverridable
      singleton
      ;
    homeStateVersion = "24.11";

    nixpkgsDefaults = {
      config = {
        allowUnfree = true;
      };
      overlays =
        attrValues self.overlays
        ++ [
        ];
    };

    primaryUserDefaults = {
      username = "berryp";
      fullName = "Berry Phillips";
      email = "berryphillips@gmail.com";
      nixConfigDirectory = "/Users/berryp/.config/nix-darwin";
    };

    systems = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
    overlays = import ./overlays {inherit inputs;};

    # Add some additional functions to `lib`.
    lib = inputs.nixpkgs.lib.extend (
      _: _: {
        mkDarwinSystem = import ./lib/mkDarwinSystem.nix inputs;
      }
    );

    darwinModules = {
      # My configurations
      berry-defaults = import ./darwin/defaults.nix;
      berry-general = import ./darwin/general.nix;
      berry-homebrew = import ./darwin/homebrew.nix;

      # Modules I've created
      users-primaryUser = import ./modules/darwin/users.nix;
      networking-hosts = import ./modules/darwin/hosts.nix;
    };

    homeManagerModules = {
      berry-configs = import ./home/config-files.nix;
      berry-packages = import ./home/packages.nix;
      berry-services = import ./home/services.nix;
      berry-fish = import ./home/fish.nix;
      berry-nushell = import ./home/nushell.nix;
      berry-git = import ./home/git.nix;
      berry-starship = import ./home/starship.nix;
      bp-podman = import ./home/podman.nix;
      # berry-git = import ./home/git.nix;
      home-user-info = {lib, ...}: {
        options.home.user-info =
          (self.darwinModules.users-primaryUser {
            inherit lib;
          })
          .options
          .users
          .primaryUser;
      };
    };

    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Berrys-MacBook-Pro
    darwinConfigurations = {
      "Berrys-MacBook-Pro" = makeOverridable self.lib.mkDarwinSystem (
        primaryUserDefaults
        // {
          system = "aarch64-darwin";
          modules =
            attrValues self.darwinModules
            ++ singleton {
              nixpkgs = nixpkgsDefaults;
              nix.registry.my.flake = inputs.self;
              networking.extraHosts = builtins.readFile (builtins.fetchurl {
                url = "https://raw.githubusercontent.com/StevenBlack/hosts/6615b81c3f573a23d9883215633e78696e8dfa5a/alternates/fakenews-gambling-porn/hosts";
                sha256 = "19fwi0qwglhagx0g1zzk04dwaz3l065n1p7jbbvkbv5zlxazaykf";
              });
            };
          extraModules = [
            inputs.nix-index-database.darwinModules.nix-index
          ];
          inherit homeStateVersion;
          homeModules = attrValues self.homeManagerModules;
          extraHomeModules = [
            inputs.nix-index-database.hmModules.nix-index
          ];
        }
      );
    };

    nixosConfigurations = {
      vm = nixos-generators.nixosGenerate {
        system = "aarch64-linux";
        modules = [
          {
            # Pin nixpkgs to the flake input, so that the packages installed
            # come from the flake inputs.nixpkgs.url.
            nix.registry.nixpkgs.flake = nixpkgs;
            # set disk size to to 20G
            virtualisation.diskSize = 20 * 1024;
          }
          ./configuration.nix
        ];
        format = "raw";
      };
    };
  };
}
