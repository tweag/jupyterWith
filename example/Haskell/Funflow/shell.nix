let
  jupyterLibPath = ../../..;
  nixpkgsPath = jupyterLibPath + "/nix";
  jupyter = import jupyterLibPath { };
  pkgs = import nixpkgsPath { };
  dontCheck = pkgs.haskell.lib.dontCheck;

  ihaskellWithPackages = jupyter.kernels.iHaskellWith {
    #extraIHaskellFlags = "--debug";
    name = "Funflow";
    packages = p: [
      (dontCheck (p.callHackage "funflow" "1.5.0" { }))
    ];
  };

  ihaskell_labextension = import ../ihaskell_labextension.nix { inherit jupyter pkgs; };

  jupyterlabWithKernels =
    jupyter.jupyterlabWith {
      kernels = [ ihaskellWithPackages ];
      directory = jupyter.mkDirectoryWith {
        extensions = [
          ihaskell_labextension
        ];
      };
    };
in
jupyterlabWithKernels.env
