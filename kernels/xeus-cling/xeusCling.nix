{ stdenv
, fetchFromGitHub
, cmake
, zeromq
, pkgconfig
, libuuid
, cling
, pugixml
, llvm
, cppzmq
, openssl
, glibc
, cryptopp
, makeWrapper
}:
let
  xtl = stdenv.mkDerivation {
    name = "xtl";
    src = fetchFromGitHub {
      owner = "xtensor-stack";
      repo = "xtl";
      rev = "8406defd0ff3a33bc28e7122f48e6768722606d8";
      sha256 = "sha256-U4LJPGni2+Rr1V/+PiwQtkLt4w1R7LL0d5SADHtMDnc=";
    };
    buildInputs = [ cmake ];
    buildPhase = ''
    cmake
    '';
  };

  nlohmannJson = stdenv.mkDerivation {
    name = "nlohmannJson";
    src = fetchFromGitHub {
      owner = "nlohmann";
      repo = "json";
      rev = "eaac91803441a43562562c7dc9ef328beaeb505a";
      sha256 = "sha256-WlMqUtajHuwsnelesMu/7ij9KKb5bjuL6JKNx3g24M0=";
    };
    buildInputs = [ cmake ];
  };

  cxxopts = stdenv.mkDerivation {
    name = "cxxopts";
    src = fetchFromGitHub {
      owner = "jarro2783";
      repo = "cxxopts";
      rev = "66b52e6cc9f3f2429dcb01ddb90b6c2f156ac67f";
      sha256 = "sha256-E31P7hhzk+reUD2+fo5oiPXLHIfW5vbOOxP94Fd3aMk=";
    };
    buildInputs = [ cmake ];
  };

  xeus = stdenv.mkDerivation {
    name = "xeus";
    src = fetchFromGitHub {
      owner = "QuantStack";
      repo = "xeus";
      rev = "bad6b769035b2837ad635e9710966147a1f4ced0";
      sha256 = "sha256-EW2KmQd4oJ85ZZmWZzKlCJWOO4tzlerpb9FvYYi8V+s=";
    };

    buildInputs = [ cmake zeromq
                    cppzmq
                    cryptopp nlohmannJson xtl pkgconfig libuuid openssl ];


    configurePhase = ''
     mkdir build
     cd build
     cmake -DBUILD_EXAMPLES=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$out ..
     '';
  };

  xeusCling = stdenv.mkDerivation {
    name = "xeusCling";
    src = fetchFromGitHub {
      owner = "QuantStack";
      repo = "xeus-cling";
      rev = "ef04d9512be0804f883627b30d03888f77fd9a64";
      sha256 = "sha256-QiyvlPhcIKr1vrSg6TSlHOTqkf1+ct8SXyMxgcxru2M=";
    };

    buildInputs = [ cmake zeromq
                    cppzmq
                    xeus libuuid xtl pkgconfig cling pugixml cxxopts nlohmannJson llvm openssl makeWrapper ];

    cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=Release"
      "-DCMAKE_INSTALL_PREFIX=$out"
      "-DLLVM_BINARY_DIR=${cling}"
    ];

    postFixup = ''
    wrapProgram $out/bin/xcpp \
    --add-flags "-idirafter ${glibc.dev}/include" \
    --add-flags "-idirafter ${nlohmannJson}/include" \
    --add-flags "-idirafter ${xtl}/include" \
    --add-flags "-idirafter ${cling}/include" \
    --add-flags "-idirafter ${cxxopts}/include" \
    --add-flags "-idirafter ${llvm}/include"
      '';
  };
in
xeusCling
