{ stdenv, fetchurl, python, wget, fetchFromGitHub, libffi, cacert, git, cmake, llvm, ncurses, zlib, fetchgit }:

stdenv.mkDerivation rec {
  name = "cling";

  clingSrc = fetchFromGitHub {
    owner = "root-project";
    repo = "cling";
    rev = "5789f5b2eb14ff8e14e6297fe3a449d0ef794f17";
    sha256 = "06l0c9p8102prhanhv8xawzq4k8g587d46aykc2y5j7rrzsbs5hs";
  };

  clangSrc = fetchgit {
    url = "http://root.cern.ch/git/clang.git";
    rev = "7fd3024be56d751958d68ea3abeca4ab2f89dd91"; # This is the head of the cling-patches branch
    sha256 = "1ln199gsdvcjaafm2ff4fs31n8w931hiqxqcwrny9q69w6c8fyn9";
  };

  llvmSrc = fetchgit {
    url = "http://root.cern.ch/git/llvm.git";
    rev = "e0b472e46eb5861570497c2b9efabf96f2d4a485"; # This is the head of the cling-patches branch
    sha256 = "0yls35vyfcb14wghryss9xsin4cbpgkqckg72czh5jd2w0vjcmbx";
  };

  srcs = [ clingSrc llvmSrc clangSrc ];

  unpackCmd = ''
    mkdir -p ./all
    if [[ $curSrc == *"clang"* ]]; then
      cp -r $curSrc ./all/clang
    elif [[ $curSrc == *"llvm"* ]]; then
      cp -r $curSrc ./all/llvm
    else
      cp -r $curSrc ./all/cling
    fi
  '';

  buildInputs = [ python wget cacert git cmake llvm libffi ];
  propagatedBuildInputs = [ ncurses zlib ];
  configurePhase = "true";

  buildPhase = ''
    mv clang llvm/tools
    mv cling llvm/tools
    mkdir -p $out
    mkdir build
    cd build
    cmake -DCMAKE_INSTALL_PREFIX=$out -DLLVM_ENABLE_FFI=ON -DLLVM_ENABLE_RTTI=ON -DLLVM_INSTALL_UTILS=ON -DCMAKE_BUILD_TYPE=Release ../llvm
    cmake --build .
    cmake --build . --target install
  '';

  installPhase = "echo asdf";
}
