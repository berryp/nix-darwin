{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (config.xdg)
    stateHome
    ;
  inherit (lib) attrValues;
in {
  home.sessionVariables = {
    # EDITOR = "nvim";
    LESSHISTFILE = "${stateHome}/lesshst";
  };

  programs.bat.enable = true;
  programs.bat.config = {
    style = "plain";
  };

  programs.btop.enable = true;

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # fzf
  programs.fzf.enable = true;
  programs.fzf.enableBashIntegration = true;
  programs.fzf.enableFishIntegration = true;
  programs.fzf.enableZshIntegration = true;
  programs.fzf.tmux.enableShellIntegration = true;

  programs.gh.enable = true;

  # neovim
  programs.neovim.enable = true;

  programs.ssh.enable = true;
  programs.ssh.matchBlocks = {
    "*" = {
      extraOptions = {
        "UseKeychain" = "yes";
        "AddKeysToAgent" = "yes";
      };
      identityFile = [
        "~/.ssh/berryp_ed25519"
      ];
    };
  };

  # Starship
  programs.starship.enable = true;
  programs.starship.enableFishIntegration = true;

  programs.zoxide.enable = true;

  home.packages = attrValues {
    inherit
      (pkgs)
      bandwhich
      bottom
      coreutils
      curl
      du-dust
      eza
      fd
      ffmpeg
      ripgrep
      tealdeer
      thefuck
      wget
      xz
      yt-dlp
      # prefmanager
      ;

    # Languages
    inherit
      (pkgs)
      go
      ;
    # (python312.withPackages
    #   (ps: with ps; [pip]))

    # Dev tools
    inherit
      (pkgs)
      vim
      jq
      yq
      colima
      libgcrypt
      ;
    # Nix tools
    inherit
      (pkgs)
      alejandra
      cachix # adding/managing alternative binary caches hosted by Cachix
      comma # run software from without installing it
      devenv
      nil
      nix-search-cli
      ;
    # }
    # // lib.optionalAttrs pkgs.stdenv.isDarwin {
    #   inherit
    #     (pkgs)
    #     cocoapods
    #     m-cli # useful macOS CLI commands
    #     prefmanager # tool for working with macOS defaults
    #     ;
  };
}
