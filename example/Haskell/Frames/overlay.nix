_: pkgs:
let
  dontCheck = pkgs.haskell.lib.dontCheck;
  overrides = _: hspkgs: {
    singletons = dontCheck (hspkgs.callHackage "singletons" "2.4.1" { });
    th-desugar = hspkgs.callHackage "th-desugar" "1.8" { };
    Frames = hspkgs.callHackage "Frames" "0.5.1" { };
    htoml = hspkgs.callHackage "htoml" "1.0.0.2" { };
    vinyl = dontCheck (hspkgs.callHackage "vinyl" "0.10.0.1" { });
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
