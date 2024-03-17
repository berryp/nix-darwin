{
  pkgs,
  config,
  ...
}: {
  home.packages = [
  ];

  # dotfiles
  home.file = {
    # ".screenrc".source = dotfiles/screenrc;
  };

  home.sessionVariables = {
    EDITOR = "${pkgs.neovim}/bin/nvim";
  };

  #### PROGRAMS ####
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    nix-direnv.enable = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
      update = "darwin-rebuild switch --flake $HOME/.config/nix-darwin";
    };
    history.size = 10000;
    history.path = "${config.xdg.dataHome}/zsh/history";
  };

  # fzf
  programs.fzf.enable = true;
  programs.fzf.enableBashIntegration = true;
  programs.fzf.enableFishIntegration = true;
  programs.fzf.enableZshIntegration = true;
  programs.fzf.tmux.enableShellIntegration = true;

  # starship
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    settings = {
      directory.truncation_length = 2;
      gcloud.disabled = true;
      hostname.style = "bold green";
      memory_usage.disabled = true;
      username.style_user = "bold blue";
      format = "$username$hostname$directory$git_branch$git_state$git_status$cmd_duration$line_break$nix_shell$character";
      directory.style = "blue";
      character.success_symbol = "[❯](purple)";
      character.error_symbol = "[❯](red)";
      character.vicmd_symbol = "[❮](green)";
      cmd_duration.format = "[$duration]($style) ";
      cmd_duration.style = "yellow";
    };
  };

  # home-manager

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
