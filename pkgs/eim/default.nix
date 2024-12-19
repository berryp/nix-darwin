{
  stdenv,
  fetchzip,
  lib,
  pkgs,
}: let
  version = "0.1.5";
  srcs = {
    aarch64-darwin = {
      url = "https://github.com/espressif/idf-im-cli/releases/download/v${version}/eim-v${version}-macos-aarch64.zip";
      sha256 = "sha256-b6+rTiOad8WX/FAJ2VOuZmdbwqXHlwabmt4t37hWWkA=";
    };
  };
in
  stdenv.mkDerivation rec {
    name = "eim-${version}";
    pname = "eim";
    inherit version;

    src = fetchzip srcs.${pkgs.system};

    phases = ["installPhase"];

    installPhase = ''
      mkdir -p $out/bin
      cp $src/${pname} $out/bin/${pname}
      chmod +x $out/bin/${pname}
    '';

    meta = with lib; {
      description = "ESP-IDF Installation Manager - CLI";
      homepage = "https://docs.espressif.com/projects/idf-im-cli/en/latest/index.html";
      license = licenses.asl20;
      maintainers = with maintainers; [berryp];
      platforms = platforms.all;
    };
  }
