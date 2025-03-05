{pkgs, ...}: {
  home.packages = [
    pkgs.podman
  ];
  programs.fish.shellAliases = {
    docker = "${pkgs.podman}/bin/podman";
  };
}
