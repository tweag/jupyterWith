with (import ../. { });
let
  pkgs = import ../nix { };
  custom-ihaskell = import ./custom-ihaskell.nix;
  test-kernel-path = pkgs.callPackage ./test-kernel-path.nix { };

  includedKernels = with kernels; [
    (ansibleKernel {
      name = "test";
    })

    (cKernelWith {
      name = "test";
    })

    (gophernotes {
      name = "test";
    })

    (iHaskellWith {
      name = "test";
    })

    # Doesn't build without a nmp install due to zeromq. Needs sandbox off.
    #( iJavascript {
    #   name = "test";
    #})

    (iPythonWith {
      name = "test";
    })

    (iNixKernel {
      name = "test";
    })

    # Fails on MacOS.
    #( iRubyWith {
    #    name = "test";
    #})

    # Juniper has been removed from rPackages for some reason.
    #( juniperWith {
    #    name = "test";
    #})

    # Fails on MacOS.
    #( iRWith {
    #    name = "test";
    #})

    # This is hard to make work. We will work on it later.
    #( xeusCling {
    #    name = "test";
    #})

    (rustWith {
      name = "test";
    })
  ];

  customIHaskellKernels = with kernels; [
    # One kernel which uses a custom ihaskell + the nixpkgs haskell package set
    (iHaskellWith {
      name = "test";
      customIHaskell = custom-ihaskell.customIHaskell;
    })
    # And another which uses a custom ihaskell + the haskell.nix haskell package set
    (iHaskellWith {
      name = "test";
      customIHaskell = custom-ihaskell.customIHaskell;
      haskellPackages = custom-ihaskell.haskellPackages;
    })
  ];

  jupyterlab =
    jupyterlabWith {
      kernels = includedKernels;
    };

  jupyterlabCustomIHaskell =
    jupyterlabWith {
      kernels = customIHaskellKernels;
    };

  # Made for uploading to cachix:
  # nix-build -A build | cachix push jupyterwith
  build = jupyterlab;
  build-custom-ihaskell = jupyterlabCustomIHaskell;

  shell = jupyterlab.env;

  docker = mkDockerImage { inherit jupyterlab; };

  kernel-tests = {
    # Note: joining these to avoid creating so many "result" directories in the working directory
    core = pkgs.symlinkJoin {
      name = "test-kernel-paths-core";
      paths = (builtins.map test-kernel-path includedKernels);
    };
    customIHaskell = pkgs.symlinkJoin {
      name = "test-kernel-paths-ihaskell";
      paths = (builtins.map test-kernel-path customIHaskellKernels);
    };
  };

in
{ inherit build build-custom-ihaskell docker shell kernel-tests; }
