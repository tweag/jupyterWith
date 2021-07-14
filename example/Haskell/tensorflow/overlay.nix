_: pkgs:
let
  dontCheck = pkgs.haskell.lib.dontCheck;
  overrides = _: hspkgs: {
    conduit-extra = dontCheck hspkgs.conduit-extra;
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
