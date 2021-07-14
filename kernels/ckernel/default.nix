{ stdenv
, python3
, name ? "nixpkgs"
, packages ? p: [ ]
, pkgs
}:
let
  kernelEnv = python3.withPackages (p: [ p.jupyter_c_kernel ]);

  kernelFile = {
    argv = [
      "${kernelEnv.interpreter}"
      "-m"
      "jupyter_c_kernel"
      "-f"
      "{connection_file}"
    ];
    display_name = "C - " + name;
    language = "c";
    logo64 = "logo-64x64.svg";
  };

  cKernel = stdenv.mkDerivation {
    name = "c-kernel";
    phases = "installPhase";
    src = ./c.png;
    buildInputs = [ ];
    installPhase = ''
      mkdir -p $out/kernels/c_${name}
      cp $src $out/kernels/c_${name}/logo-64x64.png
      echo '${builtins.toJSON kernelFile}' > $out/kernels/c_${name}/kernel.json
    '';
  };
in
{
  spec = cKernel;
  runtimePackages = packages pkgs;
}
