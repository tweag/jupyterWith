# A custom IHaskell and haskellPackages built using a package set from haskell.nix instead of nixpkgs
with (import ../. { });
let
  haskellNixSrc = (import
    (builtins.fetchGit {
      url = https://github.com/input-output-hk/haskell.nix;
      rev = "240403fbae3d28ba26e965bf22feabf89156916c";
    })
    { });
  # Using the nixpkgs from jupyterWith + the overlays, etc. from haskell.nix
  pkgs = import ../nix (with haskellNixSrc.nixpkgsArgs; { inherit config overlays; });
  snapshot = pkgs.lib.getAttr "lts-16.9" pkgs.haskell-nix.snapshots;

  # ihaskell coming from haskell.nix needs to include both the exe and library components
  # in order to work properly with jupyterWith.
  customIHaskell = pkgs.symlinkJoin {
    name = "ihaskell-hnix";
    paths = [
      snapshot.ihaskell.components.exes.ihaskell
      snapshot.ihaskell.components.library
    ];
  };
in
{
  inherit customIHaskell;
  haskellPackages = snapshot;
}
