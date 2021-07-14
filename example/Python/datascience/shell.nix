let
  jupyterLibPath = ../../..;
  jupyter = import jupyterLibPath { };

  iPythonWithPackages = jupyter.kernels.iPythonWith {
    name = "datascience";
    packages = p: with p; [
      numpy
      scipy
      pandas
      matplotlib
      seaborn
      umap-learn
      scikitlearn
    ];
  };

  jupyterlabWithKernels = jupyter.jupyterlabWith {
    kernels = [ iPythonWithPackages ];
  };
in
jupyterlabWithKernels.env
