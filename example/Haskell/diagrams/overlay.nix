_: pkgs:
let
  dontCheck = pkgs.haskell.lib.dontCheck;
  overrides = _: hspkgs: {
    diagrams-contrib = dontCheck hspkgs.diagrams-contrib;
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
