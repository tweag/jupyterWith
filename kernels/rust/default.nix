{ stdenv
, name ? "nixpkgs"
, packages ? [ ]
, callPackage
, evcxr
, writeScriptBin
, cargo
, gcc
, binutils-unwrapped
}:
let
  kernelFile = {
    display_name = "Rust - ${name}";
    language = "Rust";
    argv = [
      "${evcxr}/bin/evcxr_jupyter"
      "--control_file"
      "{connection_file}"
    ];
    logo32 = "logo-32x32.png";
    logo64 = "logo-64x64.png";
  };

  RustKernel = stdenv.mkDerivation {
    name = "rust-${name}";
    src = ./.;
    phases = "installPhase";
    installPhase = ''
      export kerneldir="$out/kernels/rust_${name}"
      mkdir -p $kerneldir
      cp $src/logo-32x32.png $kerneldir/logo-32x32.png
      cp $src/logo-64x64.png $kerneldir/logo-64x64.png
      echo '${builtins.toJSON kernelFile}' > $kerneldir/kernel.json
    '';
  };
in
{
  spec = RustKernel;
  runtimePackages = [ cargo gcc binutils-unwrapped ] ++ packages;
}
