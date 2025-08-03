{
  stdenv,
  zig,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "zsmooth";
  version = "0.12";
  src = fetchFromGitHub {
    owner = "adworacz";
    repo = pname;
    rev = version;
    sha256 = "sha256-yqw6C9IpsnI/iC1YSfaXKYpNqbv68UOBLwK0YDSq75c=";
  };
  buildInputs = [
    zig.hook
  ];

    postInstall = ''
        mkdir "$out/lib/vapoursynth"
        mv "$out/lib/libzsmooth.so" "$out/lib/vapoursynth"
    '';
}
