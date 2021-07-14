let
  jupyterLibPath = ../../..;
  jupyter = import jupyterLibPath { };

  jupyterlabWithKernels = jupyter.jupyterlabWith {
    kernels = [ (jupyter.kernels.cKernelWith { name = "basic"; }) ];
  };
in
jupyterlabWithKernels.env
