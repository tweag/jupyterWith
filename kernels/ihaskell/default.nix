{ writeScriptBin
, haskellPackages
, stdenv
, lib
, customIHaskell ? null
, extraIHaskellFlags ? ""
, name ? "nixpkgs"
, packages ? (_:[])
}:

let
  # By default we use the ihaskell included in the `haskellPackages` set, but you can 
  # also specify one explicitely in case the ihaskell you want to use resides somewhere
  # else. Note that you will likely need an ihaskell which was built using the same
  # ghc as the one used by `haskellPackages`.
  ihaskell = if customIHaskell == null then haskellPackages.ihaskell else customIHaskell;

  ghcEnv = haskellPackages.ghcWithPackages (self: [ihaskell] ++ packages self);

  ghciBin = writeScriptBin "ghci-${name}" ''
    ${ghcEnv}/bin/ghci "$@"
  '';

  ghcBin = writeScriptBin "ghc-${name}" ''
    ${ghcEnv}/bin/ghc "$@"
  '';

  ihaskellSh = writeScriptBin "ihaskell" ''
    #! ${stdenv.shell}
    export GHC_PACKAGE_PATH="$(echo ${ghcEnv}/lib/*/package.conf.d| tr ' ' ':'):$GHC_PACKAGE_PATH"
    export PATH="${lib.makeBinPath ([ ghcEnv ])}:$PATH"
    ${ihaskell}/bin/ihaskell ${extraIHaskellFlags} -l $(${ghcEnv}/bin/ghc --print-libdir) "$@"'';

  kernelFile = {
    display_name = "Haskell - " + name;
    language = "haskell";
    argv = [
      "${ihaskellSh}/bin/ihaskell"
      "kernel"
      "{connection_file}"
      "+RTS"
      "-M3g"
      "-N2"
      "-RTS"
    ];
    logo64 = "logo-64x64.svg";
  };

  ihaskellKernel = stdenv.mkDerivation {
    name = "ihaskell-kernel";
    phases = "installPhase";
    src = ./haskell.svg;
    buildInputs = [ ghcEnv ];
    installPhase = ''
      mkdir -p $out/kernels/ihaskell_${name}
      cp $src $out/kernels/ihaskell_${name}/logo-64x64.svg
      echo '${builtins.toJSON kernelFile}' > $out/kernels/ihaskell_${name}/kernel.json
    '';
  };
in
  {
    spec = ihaskellKernel;
    runtimePackages = [
      # Give access to compiler and interpreter with the libraries accessible
      # from the kernel.
      ghcBin
      ghciBin
    ];
  }
