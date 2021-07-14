let
  jupyterLibPath = ../../..;
  jupyter = import jupyterLibPath { };

  iNix = jupyter.kernels.iNixKernel {
    name = "nix-kernel";
  };

  jupyterEnvironment =
    jupyter.jupyterlabWith {
      kernels = [ iNix ];
    };
in
jupyterEnvironment.env
