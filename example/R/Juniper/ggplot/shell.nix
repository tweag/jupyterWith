let
  jupyterLibPath = ../../../..;
  jupyter = import jupyterLibPath { };

  jupyterlabWithKernels = jupyter.jupyterlabWith {
    kernels = [
      (jupyter.kernels.juniperWith {
        name = "ggplot";
        packages = p: with p; [ ggplot2 ];
      })
    ];
  };
in
jupyterlabWithKernels.env
