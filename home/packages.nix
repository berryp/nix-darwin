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

  programs.bat = {
    enable = true;
    config = {
      style = "plain";
    };
  };

  programs.btop.enable = true;

  programs.htop = {
    enable = true;
    settings.show_program_path = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    # Enable custom layouts dir
    stdlib = ''
      : ''${XDG_CACHE_HOME:=$HOME/.cache}
      declare -A direnv_layout_dirs
      direnv_layout_dir() {
          echo "''${direnv_layout_dirs[$PWD]:=$(
              echo -n "$XDG_CACHE_HOME"/direnv/layouts/
              echo -n "$PWD" | shasum | cut -d ' ' -f 1
          )}"
      }
    '';
  };

  # fzf
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    tmux.enableShellIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };

  programs.gh.enable = true;

  # neovim
  programs.neovim.enable = true;

  programs.ssh = {
    enable = true;
    matchBlocks = {
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
  };

  # Starship
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.zoxide.enable = true;

  home.packages = attrValues {
    inherit
      (pkgs)
      bandwhich
      bottom
      coreutils
      curl
      du-dust
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
      cargo
      go
      go-tools
      gopls
      gotools
      python312
      rustc
      ;

    inherit
      (pkgs.python312Packages)
      pip
      requests
      ;

    # Dev tools
    inherit
      (pkgs)
      colima
      jq
      libgcrypt
      sqlite-interactive
      vim
      watch
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
