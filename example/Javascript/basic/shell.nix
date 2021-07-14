let
  jupyterLibPath = ../../..;
  jupyter = import jupyterLibPath { };

  jupyterlabWithKernels = jupyter.jupyterlabWith {
    kernels = [ (jupyter.kernels.iJavascript { name = "basic"; }) ];
  };
in
jupyterlabWithKernels.env
