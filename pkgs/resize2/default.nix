{
  stdenv,
  fetchFromGitHub,
  meson,
  pkg-config,
  vapoursynth,
  cmake,
  ninja,
  zimg,
  pkgsStatic,
}: let
  resize2-src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "vapoursynth-resize2";
    rev = "0.3.3";
    sha256 = "sha256-dqr7EL8AOcyiWnq1ivAsIxr/QTmz6iBZ3nkHYNrzAPY=";
  };
  zimg-patched = pkgsStatic.zimg.overrideAttrs (old: {
    src = fetchFromGitHub {
      owner = "sekrit-twc";
      repo = "zimg";
      rev = "39270722912e3953d8dc37a92c200b5158054ff1";
      sha256 = "sha256-99YOBAzgWVl5UNYJeiqgJjW9TpgCtJVGPFBbtZk4b8Q=";
      fetchSubmodules = true;
    };
    patches =
      old.patches or []
      ++ [
        "${resize2-src}/subprojects/packagefiles/zimg/0001.patch"
        # (fetchpatch {
        #   url = "https://raw.githubusercontent.com/Jaded-Encoding-Thaumaturgy/vapoursynth-resize2/refs/heads/master/subprojects/packagefiles/zimg/0001.patch";
        #   sha256 = "sha256-grkU57lxYOMf7lGYZ16BVAJJDpjHbaj57o4U0F7EXDI=";
        # })
      ];
    # prePatch = ''
    #   cp "${resize2-src}/subprojects/packagefiles/zimg/meson.build" .
    #   cp "${resize2-src}/subprojects/packagefiles/zimg/meson_options.txt" .
    # '';

    # CXXFLAGS = "-static";

    # nativeBuildInputs = old.nativeBuildInputs or [] ++ [meson ninja pkg-config cmake vapoursynth];
    postInstall = ''
      DIR="$dev/include"
      mkdir -p $DIR

      cp -a graphengine/include/* $DIR
      cp -a src/zimg/* $DIR
      cp -a src/* $DIR
    '';
  });
in
  stdenv.mkDerivation rec {
    pname = "vapoursynth-resize2";
    version = "0.3.3";
    src = resize2-src;

    propagatedBuildInputs = [zimg-patched];

    prePatch = ''
      substituteInPlace meson.build  \
          --replace zimg_patched zimg \
          --replace "join_paths(vapoursynth_dep.get_variable(pkgconfig: 'libdir'), 'vapoursynth')" "'lib/vapoursynth'" \
          --replace "link_args: ['-static']," "" \

      # substituteInPlace resize.cpp --replace zimg/api/zimg++.hpp zimg++.hpp
    '';

    buildInputs = [
      meson
      pkg-config
      vapoursynth
      cmake
      ninja
    ];
  }
