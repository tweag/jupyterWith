let
  jupyterLibPath = ../../..;
  jupyter = import jupyterLibPath { };

  jupyterlabWithKernels = jupyter.jupyterlabWith {
    kernels = [ (jupyter.kernels.rustWith { }) ];
  };
in
jupyterlabWithKernels.env
