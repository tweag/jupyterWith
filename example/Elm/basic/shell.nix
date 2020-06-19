let
  jupyterLibPath = ../../..;
  jupyter = import jupyterLibPath {};

  jupyterlabWithKernels = jupyter.jupyterlabWith {
      kernels = [ (jupyter.kernels.elmKernel {name="basic";}) ];
  };
in
  jupyterlabWithKernels.env
