# Author: Viacheslav Lotsmanov
# License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE

# This module is intended to be called with ‘nixpkgs.callPackage’
{ callPackage

, perl

# Build options
, extraPerlDependencies ? perlPkgs: []
}:

perl.withPackages (perlPackages:
  let
    perlPkgs =
      perlPackages //
      (callPackage ./dependencies.nix { inherit perlPackages; });
  in
  [
    perlPkgs.NeovimExt
    # Propagated dependencies for NeovimExt
    # (for some reason they do not propagate automatically, it doesn’t work without it)
    perlPkgs.ClassAccessor
    perlPkgs.EvalSafe
    perlPkgs.IOAsync
    perlPkgs.MsgPackRaw

    perlPkgs.Appcpanminus # Neovim :checkhealth reports it’s missing
    perlPkgs.locallib
  ]
  ++ extraPerlDependencies perlPkgs
)
