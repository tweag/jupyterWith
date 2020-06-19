{ python3
, stdenv
, name ? "nixpkgs"
, packages ? (_:[])
}:

let
  kernelEnv = python3.withPackages (p:
    packages p ++ (with p; [
      elm_kernel
    ])
  );

  kernelFile = {
    display_name = "Elm - ${name}";
    language = "elm";
    argv = [
      "${kernelEnv.interpreter}"
      "-m"
      "elm_kernel"
      "-f"
      "{connection_file}"
    ];
    logo64 = "logo-64x64.svg";
  };

  elmKernel = stdenv.mkDerivation {
    name = "elm-${name}";
    src = ./elm.svg;
    phases = "installPhase";
    installPhase = ''
      mkdir -p $out/kernels/elm_${name}
      cp $src $out/kernels/elm_${name}/logo-64x64.svg
      echo '${builtins.toJSON kernelFile}' > $out/kernels/elm_${name}/kernel.json
    '';
  };
in
  {
    spec = elmKernel;
    runtimePackages = [];
  }
