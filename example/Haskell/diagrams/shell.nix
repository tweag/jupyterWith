let
  jupyterLibPath = ../../..;
  jupyter = import jupyterLibPath {
    overlays = [ (import ./overlay.nix) ];
  };
  nixpkgsPath = jupyterLibPath + "/nix";
  pkgs = import nixpkgsPath { };

  ihaskellWithPackages = jupyter.kernels.iHaskellWith {
    name = "Frames";
    packages = p: with p; [
      diagrams
      ihaskell-diagrams
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
