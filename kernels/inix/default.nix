{ python3
, stdenv
, name ? "nixpkgs"
, callPackage
, nix
, writeScriptBin
}:
let
  nix-kernel = callPackage ./nix-kernel { };
  kernelEnv = (python3.withPackages (p: (with p; [
    nix-kernel
  ])
  ));

  kernelFile = {
    display_name = "Nix - ${name}";
    language = "Nix";
    argv = [
      "${nix-bin}/bin/nix-kernel"
      "-f"
      "{connection_file}"
    ];
    logo64 = "logo-64x64.png";
  };

  nix-bin = writeScriptBin "nix-kernel" ''
    #! ${stdenv.shell}
    PATH=${nix}/bin/:${kernelEnv}/bin:$PATH
    exec python -m nix-kernel $@
  '';

  iNixKernel = stdenv.mkDerivation {
    name = "inix-${name}";
    src = ./nix.png;
    phases = "installPhase";
    installPhase = ''
      mkdir -p $out/kernels/inix_${name}
      cp $src $out/kernels/inix_${name}/logo-64x64.png
      echo '${builtins.toJSON kernelFile}' > $out/kernels/inix_${name}/kernel.json
    '';
  };
in
{
  spec = iNixKernel;
  runtimePackages = [
  ];
}
