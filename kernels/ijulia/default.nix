{ pkgs
, stdenv
, name ? "nixpkgs"
, packages ? (_:[])
, extraPackages ? (_:[])
, writeScriptBin
, runCommand
, directory
, NUM_THREADS ? 1
, cuda ? false
, cudaVersion ? ""
, nvidiaVersion ? ""
}:

let
  julia_override = pkgs.julia_13.overrideAttrs(oldAttrs: {checkTarget = "";});
  extraLibs = with pkgs;[
    mbedtls
    zeromq3
    # ImageMagick.jl
    imagemagickBig
    # GZip.jl # Required by DataFrames.jl
    gzip    
    zlib
  ] ++ (extraPackages  pkgs) ++ pkgs.lib.optionals cuda
    [
      cudaVersion
      # Flux.jl
      libGLU
		  xorg.libXi xorg.libXmu freeglut
      xorg.libXext xorg.libX11 xorg.libXv xorg.libXrandr zlib
		  ncurses5
		  stdenv.cc
		  binutils
      git gitRepo gnupg autoconf curl      
      procps gnumake utillinux m4 gperf unzip
    ];

  julia_wrapped = pkgs.stdenv.mkDerivation rec {
    name = "julia_wrapped";
    buildInputs = [ julia_override ] ++ extraLibs;
    nativeBuildInputs = with pkgs; [ makeWrapper cacert git pkgconfig which ];
    phases = [ "installPhase" ];
    installPhase = ''
      export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath extraLibs}
       ${if cuda then ''
      makeWrapper ${julia_override}/bin/julia $out/bin/julia_wrapped \
      --set JULIA_DEPOT_PATH ${directory} \
      --prefix LD_LIBRARY_PATH : "$LD_LIBRARY_PATH" \
      --prefix LD_LIBRARY_PATH ":" "${nvidiaVersion}/lib" \
      --set JULIA_PKG_SERVER pkg.julialang.org \
      --set JULIA_PKGDIR ${directory} \
      --set JULIA_NUM_THREADS ${toString NUM_THREADS} \
       --set CUDA_PATH "${cudaVersion}"
      ''
         else ''
      makeWrapper ${julia_override}/bin/julia $out/bin/julia_wrapped \
      --set JULIA_DEPOT_PATH ${directory} \
      --prefix LD_LIBRARY_PATH : "$LD_LIBRARY_PATH" \
      --set JULIA_PKG_SERVER pkg.julialang.org \
      --set JULIA_NUM_THREADS ${toString NUM_THREADS} \
      --set JULIA_PKGDIR ${directory}
         ''
        }
    '';
  };

  kernelFile = {
    display_name = "Julia - ${name}";
    language = "julia";
    argv = [
      "${julia_wrapped}/bin/julia_wrapped"
      "-i"
      "--startup-file=yes"
      "--color=yes"
      "${directory}/packages/IJulia/DrVMH/src/kernel.jl"
      "{connection_file}"
    ];

    logo64 = "logo-64x64.png";

    env =   {
      LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath extraLibs}";
      JULIA_DEPOT_PATH = "${directory}";
      JULIA_PKGDIR = "${directory}";
      JULIA_NUM_THREADS= "${toString NUM_THREADS}";
    };
  };

  Install_JuliaCUDA = writeScriptBin "Install_Julia_CUDA" ''
  ${julia_wrapped}/bin/julia_wrapped -e 'using Pkg; Pkg.add(["CUDAdrv", "CUDAnative", "CuArrays"]); using CUDAdrv, CUDAnative, CuArrays' \
    && ${julia_wrapped}/bin/julia_wrapped -e 'using Pkg; Pkg.test("CUDAnative");'
  get_nvdisasm=$(dirname ${directory}/artifacts/*/bin/nvdisasm)
  rm -rf $get_nvdisasm/nvdisasm
  ln -s ${cudaVersion}/bin/nvdisasm  $get_nvdisasm/nvdisasm
  '';

  InstalliJulia = writeScriptBin "Install_iJulia" ''
     ${julia_wrapped}/bin/julia_wrapped -e 'using Pkg; Pkg.update(); Pkg.add("IJulia")'
     ${julia_wrapped}/bin/julia_wrapped -e 'using Pkg; Pkg.add("MbedTLS")'
     ## specific a MbedTLS version that fixes the MbedTls(Nix) can not load library
       ${julia_wrapped}/bin/julia_wrapped -e 'using Pkg; Pkg.pin(PackageSpec(name="MbedTLS", version="0.7.0")); using MbedTLS; using IJulia'
'';

  JuliaKernel = stdenv.mkDerivation {
    name = "Julia-${name}";
    src = ./julia.png;
    phases = "installPhase";
    installPhase = ''
      mkdir -p $out/kernels/julia_${name}
      cp $src $out/kernels/julia_${name}/logo-64x64.png
      echo '${builtins.toJSON kernelFile}' > $out/kernels/julia_${name}/kernel.json
    '';
  };

in
{
  spec = JuliaKernel;
  runtimePackages = [
    julia_wrapped
    InstalliJulia
    Install_JuliaCUDA
  ];
}
