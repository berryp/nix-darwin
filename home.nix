{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) attrValues;
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (config.xdg)
      cacheHome
      configHome
      dataHome
      stateHome
      ;
  nixConfigDirectory = "/Users/berryp/.config/nix-darwin";
in {
# Enable XDG Base Directory support
xdg.enable = true;
home.preferXdgDirectories = true;

# 1Password CLI plugin integration
  # https://developer.1password.com/docs/cli/shell-plugins/nix
  programs._1password-shell-plugins.enable = true;
  programs._1password-shell-plugins.plugins = attrValues {
    inherit (pkgs) gh cachix;
  };
  # Setup tools to work with 1Password
   home.sessionVariables = {
     GITHUB_TOKEN = "op://Personal/GitHub/GitHub CLI";
   };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.ssh.enable = true;

  programs.zoxide.enable = true;

  # neovim
  programs.neovim.enable = true;
  xdg.configFile."nvim".source = mkOutOfStoreSymlink "${nixConfigDirectory}/configs/nvim";

  home.packages = attrValues {
    # Basics
    inherit
      (pkgs)
      bottom # fancy version of `top` with ASCII graphs
      coreutils
      curl
      du-dust # fancy version of `du`
      eza # fancy version of `ls`
      fd # fancy version of `find`
      ripgrep # better version of `grep`
      tealdeer # rust implementation of `tldr`
      thefuck
      wget
      xz
      ;

    # Dev tools
    inherit
      (pkgs)
      vim
      jq
      yq
      ;

    # Nix tools
    inherit
      (pkgs)
      alejandra
      cachix # adding/managing alternative binary caches hosted by Cachix
      comma # run software from without installing it
      devenv
      nil
      ;
  };

  home.sessionVariables = {
    # EDITOR = "nvim";
  };

  # Less
home.sessionVariables.LESSHISTFILE = "${stateHome}/lesshst";

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}
