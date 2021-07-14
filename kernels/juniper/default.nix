{ stdenv
, rWrapper
, rPackages
, name ? "nixpkgs"
, packages ? (_: [ ])
}:
let
  kernelEnv = rWrapper.override {
    packages = (packages rPackages) ++ [ rPackages.JuniperKernel ];
  };

  kernelFile = {
    argv = [
      "${kernelEnv}/bin/R"
      "--slave"
      "-e"
      "JuniperKernel::bootKernel()"
      "--args"
      "{connection_file}"
    ];
    display_name = "R - " + name;
    language = "R";
    logo64 = "logo-64x64.svg";
  };

  jKernel = stdenv.mkDerivation {
    name = "juniper";
    phases = "installPhase";
    src = ./juniper.png;
    buildInputs = [ ];
    installPhase = ''
      mkdir -p $out/kernels/juniper_${name}
      cp $src $out/kernels/juniper_${name}/logo-64x64.png
      echo '${builtins.toJSON kernelFile}' > $out/kernels/juniper_${name}/kernel.json
    '';
  };
in
{
  spec = jKernel;
  runtimePackages = [ ];
}
