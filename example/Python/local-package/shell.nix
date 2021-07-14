let
  jupyterLibPath = ../../..;
  jupyter = import jupyterLibPath { };

  iPythonWithPackages = jupyter.kernels.iPythonWith {
    name = "local-package";
    packages = p:
      let
        myPythonPackage = p.buildPythonPackage {
          pname = "my-python-package";
          version = "0.1.0";
          src = ./my-python-package;
        };
      in
      [ myPythonPackage ];
  };

  jupyterlabWithKernels = jupyter.jupyterlabWith {
    kernels = [ iPythonWithPackages ];
    extraPackages = p: [ p.hello ];
  };
in
jupyterlabWithKernels.env
