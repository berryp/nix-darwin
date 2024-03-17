# Bootstrap:
# nix --extra-experimental-features "nix-command flakes" run nix-darwin -- --flake github:berryp/nix-darwin
# nix run nix-darwin --experimental-feature nix-command --experimental-feature flakes -- switch --flake ~/.config/nix-darwin
# Update:
# nix flake update && darwin-rebuild switch --flake $HOME/.config/nix-darwin
# Optional: nix flake update --commit-lock-file
{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    home-manager,
    darwin,
    nixpkgs,
  }: {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations = {
      "Berrys-Mac-mini" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.berryp = import ./home.nix;
            # home-manager.extraSpecialArg =
          }
        ];
      };
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."Berrys-Mac-mini".pkgs;
  };
}
