let
  overlay = _: pkgs: (
    let
      highchartsSrc = pkgs.fetchFromGitHub {
        owner = "MMesch";
        repo = "highcharts-hs";
        rev = "d2550fa2ece2c8c6da785e749363f8107e7ee916";
        sha256 = "08ansgnihbg9qihs86lybd37vp5h2x3yih0dxjg2zqq1w8pp184i";
      };
    in
    {
      haskellPackages = pkgs.haskellPackages.override (old: {
        overrides = pkgs.lib.composeExtensions old.overrides
          (self: hspkgs: {
            highcharts = hspkgs.callCabal2nix "highcharts" "${highchartsSrc}/highcharts" { };
            highcharts-gen = hspkgs.callCabal2nix "highcharts-gen" "${highchartsSrc}/highcharts-gen" { };
            js-qq = hspkgs.callCabal2nix "js-qq" "${highchartsSrc}/js-qq" { };
            highcharts-types = hspkgs.callCabal2nix "highcharts-types"
              (pkgs.runCommand "foo"
                { buildInputs = [ self.highcharts-gen ]; }
                "highcharts-gen ${highchartsSrc}/highcharts-gen/tree.json $out")
              { };
          });
      });
    }
  );

  jupyterLibPath = ../../..;
  jupyter = import jupyterLibPath { overlays = [ overlay ]; };


  ihaskellWithPackages = jupyter.kernels.iHaskellWith {
    #extraIHaskellFlags = "--debug";
    name = "highcharts";
    packages = p: with p; [
      highcharts
      highcharts-types
      js-qq
      highcharts-gen
    ];
  };

  jupyterlabWithKernels =
    jupyter.jupyterlabWith {
      kernels = [ ihaskellWithPackages ];
    };
in
jupyterlabWithKernels.env
