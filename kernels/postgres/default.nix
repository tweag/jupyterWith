{ stdenv
, python3
, name ? "nixpkgs"
, packages ? p: []
, pkgs
}:

let
  kernelEnv = python3.withPackages (p: [ p.jupyter_postgres_kernel ]);

  kernelFile = {
    argv = [
      "${kernelEnv.interpreter}"
      "-m"
      "postgres_kernel"
      "-f"
      "{connection_file}"
    ];
    display_name = "PostgreSQL - " + name;
    language = "sql";
    logo64 = "logo-64x64.svg";
  };

  postgresKernel = stdenv.mkDerivation {
    name = "postgres-kernel";
    phases = "installPhase";
    src = ./postgres.png;
    buildInputs = [];
    installPhase = ''
      mkdir -p $out/kernels/postgres_${name}
      cp $src $out/kernels/postgres_${name}/logo-64x64.png
      echo '${builtins.toJSON kernelFile}' > $out/kernels/postgres_${name}/kernel.json
    '';
  };
in
  {
    spec = postgresKernel;
    runtimePackages = packages pkgs;
  }
