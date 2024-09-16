function drs --wraps='/run/current-system/sw/bin/darwin-rebuild build --flake /Users/berryp/.config/nix-darwin' --wraps='nix run nix-darwin -- switch --flake ~/.config/nix-darwin' --wraps='darwin-rebuild switch --flake ~/.config/nix-darwin' --description 'alias drs=darwin-rebuild switch --flake ~/.config/nix-darwin'
  darwin-rebuild switch --flake ~/.config/nix-darwin $argv
  cd ~/.config/nix-darwin && git add . && git commit -m "Update configs" && git push
end
