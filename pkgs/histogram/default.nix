{
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  vapoursynth,
  pkg-config,
}:
stdenv.mkDerivation rec {
  pname = "vapoursynth-histogram";
  version = "2";
  src = fetchFromGitHub {
    owner = "dubhater";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-NME20pZZndUCcR1fY+mieBVrHxBYpB0xO1wbyghxsvE=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    vapoursynth
  ];

  postInstall = ''
    mkdir -p $out/lib/vapoursynth
    mv $out/lib/lib* $out/lib/vapoursynth
  '';
}
