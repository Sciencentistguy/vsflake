{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      overlay = final: prev: {
        vapoursynth = prev.callPackage ./pkgs/vapoursynth {};
      };
      flakePkgs = self.packages.${system};
      #pkgs = nixpkgs.legacyPackages.${system}.extend overlay;
      pkgs = import nixpkgs {
        inherit system;
        overlays = [overlay];
      };
    in {
      packages = {
        inherit (pkgs) vapoursynth;

        jetpytools = pkgs.python3Packages.callPackage ./pkgs/jetpytools {};
        vsjetpack = pkgs.python3Packages.callPackage ./pkgs/vsjetpack {
          inherit
            (flakePkgs)
            jetpytools
            vapoursynth-akarin
            vapoursynth-zip
            ;
        };

        vapoursynth-akarin = pkgs.callPackage ./pkgs/akarin {};
        vapoursynth-zip = pkgs.callPackage ./pkgs/zip {};
        vapoursynth-histogram = pkgs.callPackage ./pkgs/histogram {};
        vapoursynth-resize2 = pkgs.callPackage ./pkgs/resize2 {};
        vapoursynth-zsmooth = pkgs.callPackage ./pkgs/zsmooth {};
      };

      devShell = pkgs.stdenv.mkDerivation rec {
        name = "vsshell";
        buildInputs = [
          (
            pkgs.vapoursynth.withPlugins [
              pkgs.vapoursynth-bestsource
              pkgs.vapoursynth-znedi3
              flakePkgs.vsjetpack
              flakePkgs.vapoursynth-resize2
              flakePkgs.vapoursynth-zsmooth
              flakePkgs.vapoursynth-histogram
            ]
          )
        ];
      };

      packages.default = self.packages.x86_64-linux.hello;
    });
}
