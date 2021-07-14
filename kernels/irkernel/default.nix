{ stdenv
, rWrapper
, rPackages
, name ? "nixpkgs"
, packages ? (_: [ ])
}:
let
  kernelEnv = rWrapper.override { packages = (packages rPackages) ++ [ rPackages.IRkernel ]; };

  kernelFile = {
    argv = [
      "${kernelEnv}/bin/R"
      "--slave"
      "-e"
      "IRkernel::main()"
      "--args"
      "{connection_file}"
    ];
    display_name = "R - " + name;
    language = "R";
    logo64 = "logo-64x64.png";
  };

  IRkernel = stdenv.mkDerivation {
    name = "IRkernel";
    phases = "installPhase";
    src = ./ir.svg;
    buildInputs = [ ];
    installPhase = ''
      mkdir -p $out/kernels/ir_${name}
      cp $src $out/kernels/ir_${name}/logo-64x64.svg
      echo '${builtins.toJSON kernelFile}' > $out/kernels/ir_${name}/kernel.json
    '';
  };
in
{
  spec = IRkernel;
  runtimePackages = [ ];
}
