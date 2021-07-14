let
  jupyterLib = ../../..;
  nixpkgsPath = jupyterLib + "/nix";

  pkgs = import nixpkgsPath { };

  monadBayesSrc = pkgs.fetchFromGitHub {
    owner = "adscib";
    repo = "monad-bayes";
    rev = "f55d9fa9d24d169d53bb03598306ee8c46b5fc11";
    sha256 = "1w2s5kgvdp8zfj464xmjb4kzpfsq6vc2jjakgixhs8wppq9vbvda";
  };

  hVegaSrc = pkgs.fetchFromGitHub {
    owner = "DougBurke";
    repo = "hvega";
    rev = "hvega-0.4.0.0";
    sha256 = "1pg655a36nsz7h2l1sbyk4zzzjjw4dlah8794bc0flpigr7iik13";
  };

  haskellPackages = pkgs.haskellPackages.override (old: {
    overrides = pkgs.lib.composeExtensions old.overrides
      (self: hspkgs: {
        monad-bayes = hspkgs.callCabal2nix "monad-bayes" "${monadBayesSrc}" { };
        hvega = hspkgs.callCabal2nix "hvega" "${hVegaSrc}/hvega" { };
        ihaskell-hvega = hspkgs.callCabal2nix "ihaskell-hvega" "${hVegaSrc}/ihaskell-hvega" { };
      });
  });

  jupyter = import jupyterLib { pkgs = pkgs; };

  ihaskellWithPackages = jupyter.kernels.iHaskellWith {
    #extraIHaskellFlags = "--debug";
    haskellPackages = haskellPackages;
    name = "bayes-monad";
    packages = p: with p; [
      matrix
      hmatrix
      monad-bayes
      hvega
      statistics
      vector
      ihaskell-hvega
      aeson
      aeson-pretty
      formatting
      foldl
    ];
  };

  jupyterlabWithKernels =
    jupyter.jupyterlabWith {
      kernels = [ ihaskellWithPackages ];
      directory = jupyter.mkDirectoryWith {
        extensions = [
          "jupyterlab-ihaskell"
        ];
      };
    };
in
jupyterlabWithKernels.env
