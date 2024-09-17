{
  lib,
  pkgs,
  ...
}: let
  nixConfigDirectory = "/Users/berryp/.config/nix-darwin";
in {
  # Fish Shell
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.fish.enable
  programs.fish.enable = true;

  # Add Fish plugins
  programs.fish.plugins = [
    {
      name = "done";
      src = pkgs.fishPlugins.done.src;
    }
    {
      name = "pure";
      src = pkgs.fishPlugins.pure.src;
    }
  ];

  programs.fish.functions = {
  };

  # Aliases
  programs.fish.shellAliases = with pkgs; {
    # Nix related
    drb = "darwin-rebuild build --flake ${nixConfigDirectory}";
    drs = "darwin-rebuild switch --flake ${nixConfigDirectory}";
    flakeup = "nix flake update ${nixConfigDirectory}";
    nb = "nix build";
    nd = "nix develop";
    nf = "nix flake";
    nr = "nix run";
    ns = "nix search";

    vi = "${neovim}/bin/nvim";
    vim = "${neovim}/bin/nvim";

    # Other
    ".." = "cd ..";
    ":q" = "exit";
    cat = "${bat}/bin/bat";
    du = "${du-dust}/bin/dust";
    g = "${gitAndTools.git}/bin/git";
    la = "ll -a";
    ll = "ls -l --time-style long-iso --icons";
    ls = "${eza}/bin/eza";
  };

  home.sessionPath = [
    "/run/current-system/sw/bin"
  ];

  programs.fish.shellAbbrs = {
  };

  # FIXME: This is needed to address bug where the $PATH is re-ordered by
  # the `path_helper` tool, prioritising Apple’s tools over the ones we’ve
  # installed with nix.
  #
  # This gist explains the issue in more detail: https://gist.github.com/Linerre/f11ad4a6a934dcf01ee8415c9457e7b2
  # There is also an issue open for nix-darwin: https://github.com/LnL7/nix-darwin/issues/122
  programs.fish.loginShellInit = let
    # We should probably use `config.environment.profiles`, as described in
    # https://github.com/LnL7/nix-darwin/issues/122#issuecomment-1659465635
    # but this takes into account the new XDG paths used when the nix
    # configuration has `use-xdg-base-directories` enabled. See:
    # https://github.com/LnL7/nix-darwin/issues/947 for more information.
    profiles = [
      "/etc/profiles/per-user/$USER" # Home manager packages
      "$HOME/.nix-profile"
      "(set -q XDG_STATE_HOME; and echo $XDG_STATE_HOME; or echo $HOME/.local/state)/nix/profile"
      "/run/current-system/sw"
      "/nix/var/nix/profiles/default"
    ];

    makeBinSearchPath =
      lib.concatMapStringsSep " " (path: "${path}/bin");
  in ''
    # Fix path that was re-ordered by Apple's path_helper
    fish_add_path --move --prepend --path ${makeBinSearchPath profiles}
    set fish_user_paths $fish_user_paths
  '';

  # Configuration that should be above `loginShellInit` and `interactiveShellInit`.
  programs.fish.shellInit = ''
    set -U fish_term24bit 1
  '';
  programs.fish.interactiveShellInit = ''
    set -g fish_greeting ""
    ${pkgs.thefuck}/bin/thefuck --alias | source
  '';
}
