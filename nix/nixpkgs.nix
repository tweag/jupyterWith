let
  src = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/04f436940c85b68a5dc6b69d93a9aa542cf3bf6c.tar.gz";
    sha256 = "1ln90ddn7a01x3w2as2dpc5ljb8sbif64gdp535xz2ds57kr7w59";
  };
in
import src
