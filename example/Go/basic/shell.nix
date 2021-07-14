let
  jupyterLibPath = ../../..;
  jupyter = import jupyterLibPath { };

  jupyterlabWithKernels = jupyter.jupyterlabWith {
    kernels = [ (jupyter.kernels.gophernotes { name = "basic"; }) ];
  };
in
jupyterlabWithKernels.env
