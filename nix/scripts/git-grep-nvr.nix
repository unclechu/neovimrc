# Author: Viacheslav Lotsmanov
# License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE

# This module is intended to be called with ‘nixpkgs.callPackage’
{ callPackage
, neovim-remote
, newt

# Overridable dependencies
, executable-dependencies ? callPackage ../utils/executable-dependencies.nix {}
, mk-generic-script ? callPackage ../utils/mk-generic-script.nix {}

# Build options
, __scriptSrc ? ../../apps/git-grep-nvr.sh
}:

let
  e = executable-dependencies {
    nvr = neovim-remote;
    whiptail = newt;
  };
in

mk-generic-script {
  name = "git-grep-nvr";
  src = __scriptSrc;
  inherit e;
}
