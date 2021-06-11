{ stdenv, callPackage, writeScriptBin, name ? "default" }:

let
  nodePackages = callPackage ./ijavascript-node {};

  iJavascriptEnv = nodePackages."ijavascript-5.2.0";

  iJavascriptSh = writeScriptBin "ijavascript" ''
    #! ${stdenv.shell}
    export PATH="${lib.makeBinPath ([ iJavascriptEnv ])}:$PATH"
    ${iJavascriptEnv}/lib/node_modules/ijavascript/lib/kernel.js "$@"
  '';

  kernelFile = {
    display_name = "Javascript - " + name;
    language = "javascript";
    argv = [
      "${iJavascriptSh}/bin/ijavascript"
      "{connection_file}"
    ];
    logo64 = "logo-64x64.png";
  };

  iJavascriptKernel = stdenv.mkDerivation {
    name = "ijavascript-kernel";
    src = ./javascript.png;
    buildInputs = [ iJavascriptEnv ];
    phases = "installPhase";
    installPhase = ''
      mkdir -p $out/kernels/ijavascript_${name}
      cp $src $out/kernels/ijavascript_${name}/logo-64x64.png
      echo '${builtins.toJSON kernelFile}' > $out/kernels/ijavascript_${name}/kernel.json
    '';
  };
in
  {
    spec = iJavascriptKernel;
    runtimePackages = [];
  }
