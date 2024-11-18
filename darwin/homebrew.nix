{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  brewEnabled = config.homebrew.enable;
in {
  environment.shellInit = mkIf brewEnabled ''
    eval "$(${config.homebrew.brewPrefix}/brew shellenv)"
  '';

  # https://docs.brew.sh/Shell-Completion#configuring-completions-in-fish
  # For some reason if the Fish completions are added at the end of `fish_complete_path` they don't
  # seem to work, but they do work if added at the start.
  programs.fish.interactiveShellInit = mkIf brewEnabled ''
    if test -d (brew --prefix)"/share/fish/completions"
      set -p fish_complete_path (brew --prefix)/share/fish/completions
    end

    if test -d (brew --prefix)"/share/fish/vendor_completions.d"
      set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
    end
  '';

  homebrew.enable = true;
  homebrew.onActivation.autoUpdate = true;
  homebrew.onActivation.cleanup = "zap";
  homebrew.global.brewfile = true;

  homebrew.taps = [
    "homebrew/services"
    "nrlquaker/createzap"
    "nikitabobko/tap"
  ];

  # Prefer installing application from the Mac App Store
  # homebrew.masApps = {
  #   Cardhop = 1290358394;
  #   DaisyDisk = 411643860;
  #   Fantastical = 975937182;
  #   Flighty = 1358823008;
  #   "Kagi Search" = 1622835804;
  #   Keynote = 409183694;
  #   "Notion Web Clipper" = 1559269364;
  #   Numbers = 409203825;
  #   Pages = 409201541;
  #   Parcel = 639968404;
  #   Patterns = 429449079;
  #   "Pixelmator Pro" = 1289583905;
  #   "Playgrounds" = 1496833156;
  #   "Prime Video" = 545519333;
  #   SiteSucker = 442168834;
  #   Slack = 803453959;
  #   "Tailscale" = 1475387142;
  #   "Things 3" = 904280696;
  #   Vimari = 1480933944;
  #   "WiFi Explorer" = 494803304;
  #   Xcode = 497799835;
  #   "Yubico Authenticator" = 1497506650;
  # };

  # If an app isn't available in the Mac App Store, or the version in the App Store has
  # limitations, e.g., Transmit, install the Homebrew Cask.
  homebrew.casks = [
  ];

  # Configuration related to casks

  # For cli packages that aren't currently available for macOS in `nixpkgs`.Packages should be
  # installed in `../home/default.nix` whenever possible.
  homebrew.brews = [
    "swift-format"
    "swiftlint"
  ];
}
