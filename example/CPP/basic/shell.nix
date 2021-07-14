let
  jupyterLibPath = ../../..;
  jupyter = import jupyterLibPath { };

  jupyterlabWithKernels = jupyter.jupyterlabWith {
    kernels = [ (jupyter.kernels.xeusCling { name = "basic"; }) ];
  };
in
jupyterlabWithKernels.env
