{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    darwin,
    nix-homebrew,
    ...
  } @ inputs: let
    inherit (self.lib) attrValues;

    nixpkgsDefaults = {
      config = {
        allowUnfree = true;
      };
      overlays = attrValues self.overlays ++ [];
    };

    mkDarwinSystem = {
      username ? "berryp",
      fullName ? "Berry Phillips",
      email ? "berryphillips@gmail.com",
      nixConfigDirectory ? "/Users/berryp/.config/nix-darwin",
      system ? "aarch64-darwin",
      modules ? [],
      homeStateVersion ? "24.11",
      homeModules ? [],
    }:
      darwin.lib.darwinSystem {
        inherit system;
        modules =
          modules
          ++ [
            inputs.nix-homebrew.darwinModules.nix-homebrew
            {
              nixpkgs = nixpkgsDefaults;

              nix-homebrew = {
                user = username;
                enable = true;
                enableRosetta = true;
                autoMigrate = true;
              };
            }
            inputs.home-manager.darwinModules.home-manager
            (
              {config, ...}: {
                users.primaryUser = {
                  inherit
                    username
                    fullName
                    email
                    nixConfigDirectory
                    ;
                };

                users.users.${username}.home = "/Users/${username}";
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.${username} = {
                  imports =
                    homeModules
                    ++ [
                      {
                        options.home.user-info =
                          (import ./modules/darwin/users.nix {inherit (self) lib;})
                          .options
                          .users
                          .primaryUser;
                      }
                    ];
                  home.stateVersion = homeStateVersion;
                  home.user-info = config.users.primaryUser;
                };
              }
            )
          ];
        specialArgs = inputs;
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

    lib = inputs.nixpkgs.lib.extend (_: _: {});

    darwinConfigurations = {
      "Berrys-MacBook-Pro" = mkDarwinSystem {
        modules = [
          ./darwin/defaults.nix
          ./darwin/general.nix
          ./darwin/homebrew.nix
          ./modules/darwin/users.nix
        ];
        homeModules = [
          ./home/config-files.nix
          ./home/packages.nix
          ./home/services.nix
          ./home/fish.nix
          ./home/git.nix
          ./home/direnv.nix
          ./home/starship.nix
        ];
      };
    };
  };
}
