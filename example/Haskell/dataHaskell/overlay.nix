_: pkgs:
let
  dontCheck = pkgs.haskell.lib.dontCheck;
  dataHaskellCoreSrc = pkgs.fetchFromGitHub {
    owner = "DataHaskell";
    repo = "dh-core";
    rev = "3fd4d8d62e12452745dc484459d1a5874f523df9";
    sha256 = "12z0jfhwpvk5gd1wckasy346aqm0280pv5h7jl1grpk797zjdswx";
  };

  overrides = _: hspkgs: {
    vinyl_0_10_0 = hspkgs.vinyl_0_10_0_1;
    singletons = dontCheck (hspkgs.callHackage "singletons" "2.4.1" { });
    th-desugar = hspkgs.callHackage "th-desugar" "1.8" { };
    datasets = hspkgs.callHackage "datasets" "0.4.0" { };
    streaming-cassava = dontCheck (hspkgs.callHackage "streaming-cassava" "0.1.0.1" { });
    Frames = hspkgs.callHackage "Frames" "0.5.1" { };
    htoml = hspkgs.callHackage "htoml" "1.0.0.2" { };
    vinyl = dontCheck (hspkgs.callHackage "vinyl" "0.10.0.1" { });
    dh-core = dontCheck (hspkgs.callCabal2nix "dh-core" "${dataHaskellCoreSrc}/dh-core" { });
    analyze = dontCheck (hspkgs.callCabal2nix "analyze" "${dataHaskellCoreSrc}/analyze" { });

  };
in
{
  haskellPackages = pkgs.haskellPackages.override (old: {
    overrides =
      pkgs.lib.composeExtensions
        (old.overrides or (_:_: { }))
        overrides;
  });
}
