{ writeScriptBin
, stdenv
, fetchurl
, python
, wget
, fetchFromGitHub
, libffi
, cacert
, git
, cmake
, llvm
, ncurses
, zlib
, zeromq
, pkgconfig
, libuuid
, pugixml
, fetchgit
, name ? "nixpkgs"
, packages ? (_:[])
}:

let
  cling = import ./cling.nix {inherit stdenv fetchurl python wget fetchFromGitHub libffi cacert git cmake llvm ncurses zlib fetchgit;};
  xeusCling = import ./xeusCling.nix {inherit stdenv fetchFromGitHub cmake zeromq pkgconfig libuuid cling pugixml;};

  xeusClingSh = writeScriptBin "xeusCling" ''
    #! ${stdenv.shell}
    export PATH="${lib.makeBinPath ([ xeusCling ])}:$PATH"
    ${xeusCling}/bin/xeus-cling "$@"'';

  kernelFile = {
    display_name = "C++ - " + name;
    language = "C++11";
    argv = [
      "${xeusClingSh}/bin/xeusCling"
      "-f"
      "{connection_file}"
      "-std=c++11"
      ];
    logo64 = "logo-64x64.svg";
  };

  xeusClingKernel = stdenv.mkDerivation {
    name = "xeus-cling";
    phases = "installPhase";
    src = ./xeus-cling.svg;
    buildInputs = [ xeusCling ];
    installPhase = ''
      mkdir -p $out/kernels/xeusCling_${name}
      cp $src $out/kernels/xeusCling_${name}/logo-64x64.svg
      echo '${builtins.toJSON kernelFile}' > $out/kernels/xeusCling_${name}/kernel.json
    '';
  };
in
  {
    spec = xeusClingKernel;
    runtimePackages = [];
  }
