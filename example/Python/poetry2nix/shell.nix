let
  poetry2nix = import
    (builtins.fetchGit {
      url = https://github.com/nix-community/poetry2nix;
      rev = "70c6964368406a3494d8b08c3cc37b7bc822b268";
    })
    { };

  python = poetry2nix.mkPoetryEnv {
    poetrylock = ./poetry.lock;
  };

  jupyterLibPath = ../../..;
  jupyter = import jupyterLibPath { };

  iPython = jupyter.kernels.iPythonWith {
    name = "python";
    python3 = python;
    packages = ps:
      let
        pyproject = builtins.fromTOML (builtins.readFile ./pyproject.toml);
        depAttrs = builtins.attrNames pyproject.tool.poetry.dependencies;
        getDep = attrName: builtins.getAttr attrName ps;
      in
      builtins.map getDep depAttrs;
  };

  jupyterEnvironment =
    jupyter.jupyterlabWith {
      kernels = [ iPython ];
    };
in
jupyterEnvironment.env
