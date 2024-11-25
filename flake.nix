{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

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
  in {
    # Add some additional functions to `lib`.
    lib = inputs.nixpkgs.lib.extend (
      _: _: {
        mkDarwinSystem = import ./lib/mkDarwinSystem.nix inputs;
      }
    );
    overlays = {
      # apple-silicon = _: prev:
      #   optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
      #     # Add access to x86 packages system is running Apple Silicon
      #     pkgs-x86 = import inputs.nixpkgs-unstable {
      #       system = "x86_64-darwin";
      #       inherit (nixpkgsDefaults) config;
      #     };
      #   };
    };

    darwinModules = {
      # My configurations
      berry-defaults = import ./darwin/defaults.nix;
      berry-general = import ./darwin/general.nix;
      berry-homebrew = import ./darwin/homebrew.nix;

      # Modules I've created
      users-primaryUser = import ./modules/darwin/users.nix;
    };

    homeManagerModules = {
      berry-configs = import ./home/config-files.nix;
      berry-packages = import ./home/packages.nix;
      berry-fish = import ./home/fish.nix;
      berry-git = import ./home/git.nix;
      berry-starship = import ./home/starship.nix;
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
            };
          inherit homeStateVersion;
          homeModules = attrValues self.homeManagerModules;
        }
      );
    };
  };
}
