{
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [
    terminal-notifier
    pkg-config
  ];

  programs.nix-index.enable = true;

  fonts.packages = with pkgs; [
    fira
    nerd-fonts.fira-code
    # (nerdfonts.override {fonts = ["FiraCode"];})
  ];

  #   # Networking
  # networking.dns = [
  #   "1.1.1.1" # Cloudflare
  #   "8.8.8.8" # Google
  # ];

  # Add ability to used TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;

  # Necessary for using flakes on this system.
  nix.settings = {
    experimental-features = "nix-command flakes";
    extra-nix-path = "nixpkgs=flake:nixpkgs";

    trusted-users = ["@admin" "berryp"];

    extra-substituters = [
      "https://devenv.cachix.org"
    ];
    extra-trusted-public-keys = [
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
  };

  nixpkgs.config.allowUnfree = true;

  # Add shells installed by nix to /etc/shells file
  environment.shells = with pkgs; [
    bashInteractive
    fish
    zsh
  ];

  # Create /etc/zshrc that loads the nix-darwin environment.
  # Make Fish the default shell
  programs.fish.enable = true;
  programs.fish.useBabelfish = true;
  programs.fish.babelfishPackage = pkgs.babelfish;
  # Needed to address bug where $PATH is not properly set for fish:
  # https://github.com/LnL7/nix-darwin/issues/122
  programs.fish.shellInit = ''
    for p in (string split : ${config.environment.systemPath})
      if not contains $p $fish_user_paths
        set -g fish_user_paths $fish_user_paths $p
      end
    end
  '';

  environment.variables = {
    SHELL = "${pkgs.fish}/bin/fish";
    EDITOR = "${pkgs.neovim}/bin/nvim";
  };
  # Install and setup ZSH to work with nix(-darwin) as well
  programs.zsh.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Store management
  nix.gc.automatic = true;
  nix.gc.interval.Hour = 3;
  nix.gc.options = "--delete-older-than 15d";
  nix.optimise.automatic = true;
  nix.optimise.interval.Hour = 4;

  users.users.berryp.home = "/Users/berryp";

  # nix.linux-builder = {
  #   enable = true;
  #   systems = ["aarch64-linux" "x86_64-linux"];
  # };
  #
  homebrew = {
    enable = true;
    casks = [];
    brews = [
      # "swift-format"
      # "swiftlint"
      # "jackett"
      # "cmake"
      # "ninja"
      # "dfu-util"
    ];
    masApps = {};
  };
}
