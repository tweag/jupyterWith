{ jupyter, pkgs }:
let
  ihaskellSrc = pkgs.fetchFromGitHub {
    owner = "gibiansky";
    repo = "IHaskell";
    rev = "d7dc460a421abaa41e04fe150e264bc2bab5cbad";
    # This rev does not need to be the same as the IHaskell rev
    # in ../../nix/haskell-overlay.nix
    # The ihaskell kernel and the ihaskell_labextension come from the
    # same repository but are independent.
    sha256 = "157mqfprjbjal5mvrqwpgnfvc93fn1pqwwkhfpcs7jm5c34bkv3q";
  };
in
jupyter.mkBuildExtension "${ihaskellSrc}/ihaskell_labextension"
