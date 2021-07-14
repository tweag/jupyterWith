let
  jupyterLibPath = ../../..;
  jupyter = import jupyterLibPath { };

  jupyterlabWithKernels = jupyter.jupyterlabWith {
    kernels = [
      (jupyter.kernels.iRubyWith {
        name = "basic";
        packages = p: with p; [ ];
      })
    ];
  };
in
jupyterlabWithKernels.env
