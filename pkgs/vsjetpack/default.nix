{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  rich,
  scipy,
  jetpytools,
  vapoursynth,
  vapoursynth-akarin,
  vapoursynth-zip,
  pytestCheckHook,
  hatchling,
}:
buildPythonPackage rec {
  pname = "vsjetpack";
  version = "0.5.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "vs-jetpack";
    tag = "v${version}";
    hash = "sha256-bCtWjFtp7/bjo/HTFmkxccbZ0ks6GgjCnNnZ0W2c/zg=";
  };

  build-system = [setuptools];

  dependencies = [
    numpy
    rich
    scipy
    jetpytools
    hatchling
  ];

  propagatedBuildInputs = [
    # not sure if this works properly
    vapoursynth-akarin
    vapoursynth-zip
  ];

  pythonImportsCheck = [
    "vstools"
    "vskernels"
    "vsexprtools"
    "vsrgtools"
    "vsmasktools"
    "vsaa"
    "vsscale"
    "vsdenoise"
    "vsdehalo"
    "vsdeband"
    "vsdeinterlace"
    "vssource"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    (vapoursynth.withPlugins propagatedBuildInputs)
  ];

  meta = {
    description = "Filters, wrappers, and helper functions for filtering video using VapourSynth";
    homepage = "https://jaded-encoding-thaumaturgy.github.io/vs-jetpack/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [sigmanificient];
  };
}
