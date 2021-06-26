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
, cppzmq
, openssl
, ncurses
, zlib
, zeromq
, pkgconfig
, libuuid
, pugixml
, fetchgit
, glibc
, makeWrapper
, cryptopp
, extraFlag ? "c++17"
, name ? "nixpkgs"
, packages ? (_:[])
}:

let
  cling = import ./cling.nix {inherit stdenv fetchurl python wget fetchFromGitHub libffi cacert git cmake llvm ncurses zlib fetchgit glibc makeWrapper;};
  xeusCling = import ./xeusCling.nix {inherit stdenv fetchFromGitHub cmake zeromq pkgconfig libuuid cling pugixml llvm cppzmq openssl glibc makeWrapper cryptopp;};

  xeusClingSh = writeScriptBin "xeusCling" ''
    #! ${stdenv.shell}
    export PATH="${stdenv.lib.makeBinPath ([ xeusCling ])}:$PATH"
    ${xeusCling}/bin/xcpp "$@"'';

  kernelFile = {
    display_name = "C++ - " + name;
    language = "C++17";
    argv = [
      "${xeusClingSh}/bin/xeusCling"
      "-f"
      "{connection_file}"
      "-std=${extraFlag}"
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
    runtimePackages = [
      xeusClingSh
    ];
  }
