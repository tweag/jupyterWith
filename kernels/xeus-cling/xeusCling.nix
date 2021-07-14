{ stdenv
, fetchFromGitHub
, cmake
, zeromq
, pkgconfig
, libuuid
, cling
, pugixml
}:
let
  xtl = stdenv.mkDerivation {
    name = "xtl";
    src = fetchFromGitHub {
      owner = "QuantStack";
      repo = "xtl";
      rev = "01be49d75867ee99d48bf061a913f98e12fc6704";
      sha256 = "0xy040b4b5a39kxqnj7r0bm64ic13szrli8ik95xvfh26ljh8c7q";
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
      rev = "e89c946451cfdb7392b12bc6c3674b548ea5c0ee";
      sha256 = "16rgp9rgdza82zcbh9r9i7k2yblkz2fd3ig64035fny2p6pxw6lm";
    };
    buildInputs = [ cmake ];
    buildPhase = ''
      pwd
      ls -la
      cmake
    '';
  };

  cppzmq = stdenv.mkDerivation {
    name = "cppzmq";
    src = fetchFromGitHub {
      owner = "zeromq";
      repo = "cppzmq";
      rev = "d641d1de4c8aa7f2dc674d80b3a71469364b9534";
      sha256 = "0n8xfpydrqxbzdcpmamnw27r02rslxj2rf6hp4n79ljqm5smq385";
    };
    buildInputs = [ cmake zeromq ];
  };

  cxxopts = stdenv.mkDerivation {
    name = "cxxopts";
    src = fetchFromGitHub {
      owner = "jarro2783";
      repo = "cxxopts";
      rev = "9990f73845d76106063536d7cd630ac15cb4a065";
      sha256 = "0hhw52plq7nyh1v040h1afw0kaq8rha7hvwyw8nnyyvb9kbnkqqs";
    };
    buildInputs = [ cmake ];
  };

  cryptopp = stdenv.mkDerivation rec {
    name = "crypto++-${version}";
    majorVersion = "8.0";
    version = "${majorVersion}.0";

    src = fetchFromGitHub {
      owner = "weidai11";
      repo = "cryptopp";
      rev = "CRYPTOPP_8_0_0";
      sha256 = "135p1qqzrrvkkc33y8j328pp3b6grnwka9sps77pdidrqy333bws";
    };

    configurePhase =
      let
        marchflags =
          if stdenv.isi686 then "-march=i686" else
          if stdenv.isx86_64 then "-march=nocona -mtune=generic" else
          "";
      in
      ''
        sed -i GNUmakefile \
          -e 's|-march=native|${marchflags} -fPIC|g' \
          -e '/^CXXFLAGS =/s|-g ||'
      '';

    enableParallelBuilding = true;

    makeFlags = [ "PREFIX=$(out)" ];
    buildFlags = [ "libcryptopp.so" "libcryptopp.pc" ];
    installFlags = [ "LDCONF=true" ];

    doCheck = true;
    checkPhase = "LD_LIBRARY_PATH=`pwd` make test";

    # prefer -fPIC and .so to .a; cryptotest.exe seems superfluous
    postInstall = ''
      ln -sf "$out"/lib/libcryptopp.so.${version} "$out"/lib/libcryptopp.so.${majorVersion}
    '';

    meta = with lib; {
      description = "Crypto++, a free C++ class library of cryptographic schemes";
      homepage = http://cryptopp.com/;
      license = licenses.boost;
      platforms = platforms.all;
      maintainers = [ ];
    };
  };

  xeus = stdenv.mkDerivation {
    name = "xeus";
    src = fetchFromGitHub {
      owner = "QuantStack";
      repo = "xeus";
      rev = "e77c56c0f3f9bac55be253bc8cad79e24f28ade0";
      sha256 = "0sk2g45jg09crdzx0kkbr6s5890z3ybfynwx2xbchrcvc9mgc3bd";
    };

    buildInputs = [ cmake zeromq cppzmq cryptopp nlohmannJson xtl pkgconfig libuuid ];

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
      rev = "1974c29977a87531dfd39377be32d713aa26ecf2";
      sha256 = "0i48ywiz7sgvln106phs0syd00kly0sirr8ib2hlri32j5awph8v";
    };
    buildInputs = [ cmake zeromq cppzmq xeus libuuid xtl pkgconfig cling pugixml cxxopts nlohmannJson ];

    configurePhase = ''
      echo "=======> CHECK RTTI"
      llvm-config --has-rtti
      mkdir build
      cd build
      cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$out ..
    '';
  };
in
xeusCling
