let
  jupyterLibPath = ../../..;
  jupyter = import jupyterLibPath { };

  ihaskellWithPackages = jupyter.kernels.iHaskellWith {
    name = "Local";
    packages = p: [
      (p.callPackage ./my-haskell-package { })
    ];
  };

  jupyterlabWithKernels =
    jupyter.jupyterlabWith {
      kernels = [ ihaskellWithPackages ];
    };
in
jupyterlabWithKernels.env
