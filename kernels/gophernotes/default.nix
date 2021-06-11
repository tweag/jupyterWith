{ writeScriptBin
, stdenv
, lib
, buildGoModule
, fetchFromGitHub
, name ? "nixpkgs"
}:

let
  # gophernotes is available in a newer version of the nixpkgs. Thus, this
  # package might be used after bumping those.
  gophernotes = buildGoModule rec {
    pname = "gophernotes";
    version = "0.7.1";

    src = fetchFromGitHub {
      owner = "gopherdata";
      repo = "gophernotes";
      rev = "v${version}";
      sha256 = "0hs92bdrsjqafdkhg2fk3z16h307i32mvbm9f6bb80bgsciysh27";
    };

    vendorSha256 = "1ylqf1sx0h2kixnq9f3prn3sha43q3ybd5ay57yy5z79qr8zqvxs";
  };

  gophernotesSh = writeScriptBin "gophernotes" ''
    #! ${stdenv.shell}
    export PATH="${lib.makeBinPath ([ gophernotes ])}:$PATH"
    ${gophernotes}/bin/gophernotes "$@"'';

  kernelFile = {
    display_name = "Go - " + name;
    language = "go";
    argv = [
      "${gophernotesSh}/bin/gophernotes"
      "{connection_file}"
    ];
    logo64 = "logo-64x64.svg";
  };

  gophernotesKernel = stdenv.mkDerivation {
    name = "gophernotes";
    phases = "installPhase";
    src = ./gophernotes.png;
    buildInputs = [ gophernotes ];
    installPhase = ''
      mkdir -p $out/kernels/gophernotes_${name}
      cp $src $out/kernels/gophernotes_${name}/logo-64x64.svg
      echo '${builtins.toJSON kernelFile}' > $out/kernels/gophernotes_${name}/kernel.json
    '';
  };
in
  {
    spec = gophernotesKernel;
    runtimePackages = [];
  }
