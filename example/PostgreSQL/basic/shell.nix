let
  jupyterLibPath = ../../..;
  jupyter = import jupyterLibPath {};

  jupyterlabWithKernels = jupyter.jupyterlabWith {
      kernels = [ (jupyter.kernels.postgresKernel {name="basic";}) ];
      extraPackages = p: with p; [
          postgresql
      ];
  };
in
  jupyterlabWithKernels.env
