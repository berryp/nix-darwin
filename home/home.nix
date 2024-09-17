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

imports = [
    ./fish.nix
];

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
  programs.ssh.matchBlocks = {
    "*" = {
      extraOptions = {
        "IdentityAgent" = "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
      };
     };
  };

  programs.zoxide.enable = true;

  # neovim
  programs.neovim.enable = true;
  xdg.configFile."nvim".source = mkOutOfStoreSymlink "${nixConfigDirectory}/configs/nvim";

  # fzf
  programs.fzf.enable = true;
  programs.fzf.enableBashIntegration = true;
  programs.fzf.enableFishIntegration = true;
  programs.fzf.enableZshIntegration = true;
  programs.fzf.tmux.enableShellIntegration = true;

  # jq
  programs.jq.enable = true;

  # Starship
  programs.starship.enable = true;
  programs.starship.enableFishIntegration = true;

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
      ext4fuse
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
