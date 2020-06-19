_: pkgs:
let
  packageOverrides = selfPythonPackages: pythonPackages: {

    jupyterlab = pythonPackages.jupyterlab.overridePythonAttrs (_:{
      doCheck = false;
    });

    nbconvert = pythonPackages.nbconvert.overridePythonAttrs (_:{
      doCheck = false;
    });

    jupyter_contrib_core = pythonPackages.buildPythonPackage rec {
      pname = "jupyter_contrib_core";
      version = "0.3.3";

      src = pythonPackages.fetchPypi {
        inherit pname version;
        sha256 = "e65bc0e932ff31801003cef160a4665f2812efe26a53801925a634735e9a5794";
      };
      doCheck = false;  # too much
      propagatedBuildInputs = [
        pythonPackages.traitlets
        pythonPackages.notebook
        pythonPackages.tornado
        ];
    };

    jupyter_nbextensions_configurator = pythonPackages.buildPythonPackage rec {
      pname = "jupyter_nbextensions_configurator";
      version = "0.4.1";

      src = pythonPackages.fetchPypi {
        inherit pname version;
        sha256 = "e5e86b5d9d898e1ffb30ebb08e4ad8696999f798fef3ff3262d7b999076e4e83";
      };

      propagatedBuildInputs = [
        selfPythonPackages.jupyter_contrib_core
        pythonPackages.pyyaml
        ];

      doCheck = false;  # too much
    };

    jupyter_c_kernel = pythonPackages.buildPythonPackage rec {
      pname = "jupyter_c_kernel";
      version = "1.2.2";
      doCheck = false;

      src = pythonPackages.fetchPypi {
        inherit pname version;
        sha256 = "e4b34235b42761cfc3ff08386675b2362e5a97fb926c135eee782661db08a140";
      };

      meta = with pkgs.stdenv.lib; {
        description = "Minimalistic C kernel for Jupyter";
        homepage = https://github.com/brendanrius/jupyter-c-kernel/;
        license = licenses.mit;
        maintainers = [];
      };
    };

    jupyter_postgres_kernel = pythonPackages.buildPythonPackage rec {
      pname = "postgres_kernel";
      version = "0.2.2";
      doCheck = false;

      src = pythonPackages.fetchPypi {
        inherit pname version;
        sha256 = "e7fd318baff171714d2810968bc50836100504a654381e9ce0d14da5e6639640";
      };

      postPatch = ''
        substituteInPlace setup.py \
        --replace "psycopg2>=2.6" "psycopg2>=2.7"
        '';

      propagatedBuildInputs = [
        selfPythonPackages.jupyter_client
        selfPythonPackages.ipykernel
        pythonPackages.psycopg2
        pythonPackages.tabulate
      ];

      meta = with pkgs.stdenv.lib; {
        description = "A simple Jupyter kernel for PostgreSQL";
        homepage = https://github.com/bgschiller/postgres_kernel;
        license = licenses.mit;
        maintainers = [];
      };
    };
  };

in

{
  python3 = pkgs.python3.override (old: {
    packageOverrides =
      pkgs.lib.composeExtensions
        (old.packageOverrides or (_: _: {}))
        packageOverrides;
  });
}
