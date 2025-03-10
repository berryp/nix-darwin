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

  programs.nix-index-database.comma.enable = true;

  programs.less.enable = true;
  programs.lesspipe.enable = true;

  programs.lazygit.enable = true;
  programs.keychain.enable = true;
  programs.dircolors.enable = true;

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
    direnvrcExtra = ''
      layout_poetry() {
        if [[ ! -f pyproject.toml ]]; then
          log_error 'No pyproject.toml found.  Use `poetry new` or `poetry init` to create one first.'
          exit 2
        fi

        local VENV=$(dirname $(poetry run which python))
        export VIRTUAL_ENV=$(echo "$VENV" | rev | cut -d'/' -f2- | rev)
        export POETRY_ACTIVE=1
        PATH_add "$VENV"
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

  programs.go.enable = true;
  programs.poetry.enable = true;
  programs.k9s.enable = true;

  programs.gh.enable = true;

  # neovim
  programs.neovim.enable = true;

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "*" = {
        identityFile = [
          "~/.ssh/berryp_ed25519"
        ];
        extraOptions = {
          "UseKeychain" = "yes";
          "AddKeysToAgent" = "yes";
        };
      };
    };
  };

  # Starship
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.wezterm = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    extraConfig = builtins.readFile ./wezterm.lua;
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
      termshark
      tmux
      yazi # file manager
      inetutils # networking tools
      # prefmanager
      ;

    # Applications
    inherit
      (pkgs)
      stats
      audacity
      ;

    # Languages
    inherit
      (pkgs)
      cargo
      rustc
      nodejs_23
      zig
      lua
      ;

    # Python
    inherit
      (pkgs.python312Packages)
      pip
      requests
      ;

    # Dev tools
    inherit
      (pkgs)
      pgcli
      jq
      libgcrypt
      sqlite-interactive
      vim
      watch
      yq
      eim
      ;

    # Nix tools
    inherit
      (pkgs)
      alejandra
      cachix # adding/managing alternative binary caches hosted by Cachix
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
