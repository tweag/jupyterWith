# JupyterWith IJulia

the nixpkgs doesn't have a package's manager for Julia lang.
So, run command `Install_iJulia` to install `Ijulia` and initialize JULIA_PKGDIR (in your first time of running environment)  before you launch `Jupyter notbook`.

- Julia CUDA run Command `/result/bin/Install_Julia_CUDA` to install CUDA environment

the nixpkgs doesn't have an julia package manager support.
So, run command `Install_iJulia` to install `Ijulia` before you launch `Jupyter notbook`.

```nix
## for buildEnv
 paths = [
           iJulia.runtimePackages
          ];
 ##or nix-shell BuildInputs
 buildInputs = [ iJulia.runtimePackages ]
```

The IJulia kernel can be used as follows:

```nix
{
    currentDir = builtins.getEnv "PWD";
    iJulia = jupyter.kernels.iJuliaWith {
    name =  "julia";
    ##JULIA_PKGDIR and JULIA_DEPOT_PATH which are your realpath(or in current project path).
    # EXAMPLE: or echo $(realpath ./.julia_pkgs) 
    directory = currentDir + "/.julia_pkgs";
    ##LD_LIBRARY_PATH that is dependence of LIBRARY's ennvironemt.(For Julia packages)
    extraPackages = p: with p;[
    # GZip.jl # Required by DataFrames.jl
      gzip
      zlib
    # HDF5.jl
     hdf5
    # Cairo.jl
    cairo
    ];
    # enabke multi-threads
    NUM_THREADS = 8;
    ##  enable CUDA support (for Flux.jl package)
    cuda = true;
    cudaVersion = pkgs.cudatoolkit_10_2;
    nvidiaVersion = pkgs.linuxPackages.nvidia_x11;
  };
```
