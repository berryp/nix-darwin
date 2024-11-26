{
  config,
  lib,
  pkgs,
  ...
}: let
  signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC2o35XUfVCZPxvsxowdfoY5+g4/P8Kz/ufkb81wMmuT";

  gitignore = t:
    lib.strings.splitString "\n" (lib.concatStrings (map (x: (builtins.readFile (
        builtins.fetchGit {
          url = "git@github.com:github/gitignore";
          rev = "95c8bf079cf5600d967696c7f253e352ae77d83d";
        }
        + "/${x}.gitignore"
      )))
      t));
in {
  home.file.".ssh/allowed_signers".text = "* ${signingKey}";

  programs.git = {
    enable = true;

    userEmail = config.home.user-info.email;
    userName = config.home.user-info.fullName;

    extraConfig = {
      diff.colorMoved = "default";
      pull.rebase = true;
      push.autoSetupRemote = true;
      commit.gpgsign = true;
      gpg.format = "ssh";
      user.signingkey = signingKey;
      ghq.root = "~/code";
    };

    ignores =
      [
        ".env.local"
        ".direnv/"
      ]
      ++ gitignore ["Global/macOS" "Global/Archives" "Python" "Go"];

    # Enhanced diffs
    #delta.enable = true;
    difftastic.enable = true;
    difftastic.display = "inline";

    aliases = {
      co = "checkout";
      ci = "commit";
      st = "status";
      amend = "commit --amend --no-edit";
    };
  };

  # programs.gh = {
  #   enable = true;
  #   settings.version = 1;
  #   settings.git_protocol = "ssh";
  # };
}
