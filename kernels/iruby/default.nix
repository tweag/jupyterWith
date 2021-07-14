{ bundlerApp
, python3
, stdenv
, name ? "nixpkgs"
, packages ? (_: [ ])
}:
let
  iRubyEnv = bundlerApp {
    pname = "iruby";
    gemdir = ./gemdir;
    exes = [ "iruby" ];
  };

  pythonEnv = python3.withPackages (p: with p; [ jupyter ipykernel ]);

  kernelFile = {
    display_name = "IRuby - ${name}";
    language = "ruby";
    argv = [
      "${iRubyEnv}/bin/iruby"
      "kernel"
      "{connection_file}"
    ];
    logo64 = "logo-64x64.svg";
  };

  irubyKernel = stdenv.mkDerivation {
    name = "iruby-${name}";
    phases = "installPhase";
    src = ./ruby.svg;
    installPhase = ''
      mkdir -p $out/kernels/iruby_${name}
      cp $src $out/kernels/iruby_${name}/logo-64x64.svg
      echo '${builtins.toJSON kernelFile}' > $out/kernels/iruby_${name}/kernel.json
    '';
  };
in
{
  spec = irubyKernel;
  runtimePackages = [ ];
}
