{config, ...}: let
  signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC2o35XUfVCZPxvsxowdfoY5+g4/P8Kz/ufkb81wMmuT";
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

    ignores = [
      "*~"
      ".DS_Store"
    ];

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

  programs.gh = {
    enable = true;
    settings.version = 1;
    settings.git_protocol = "ssh";
  };
}
