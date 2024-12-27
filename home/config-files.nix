{config, ...}: let
  inherit (config.home.user-info) nixConfigDirectory;
  inherit (config.lib.file) mkOutOfStoreSymlink;
in {
  # Enable XDG Base Directory support
  xdg.enable = true;
  home.preferXdgDirectories = true;

  xdg.configFile."nvim".source = mkOutOfStoreSymlink "${nixConfigDirectory}/configs/nvim";
  # xdg.configFile."gh".source = mkOutOfStoreSymlink "${nixConfigDirectory}/configs/gh";
  xdg.configFile."aerospace/aerospace.toml".source = mkOutOfStoreSymlink "${nixConfigDirectory}/configs/aerospace/aerospace.toml";
  xdg.configFile."ghostty/config".source = mkOutOfStoreSymlink "${nixConfigDirectory}/configs/ghostty/config";
}
