{
  stdenv,
  fetchzip,
}:
stdenv.mkDerivation rec {
  name = "eim-${version}";
  pname = "eim";
  version = "0.1.5";

  src = fetchzip {
    url = "https://github.com/espressif/idf-im-cli/releases/download/v${version}/eim-v${version}-macos-aarch64.zip";
    sha256 = "sha256-4CkijAlenhht8tyk3nBULaBPE0GBf6DVII699/RmmWI=";
  };

  phases = ["installPhase"];

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/eim
    chmod +x $out/bin/eim
  '';
}
