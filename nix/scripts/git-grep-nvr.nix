# This module is intended to be called with ‘nixpkgs.callPackage’
{ callPackage
, bash
, neovim-remote
, newt

# Overridable dependencies
, __utils ? callPackage ../utils.nix {}

# Build options
, __scriptSrc ? ../../apps/git-grep-nvr.sh
}:
let
  inherit (__utils) esc nameOfModuleFile writeCheckedExecutable shellCheckers valueCheckers;

  name = nameOfModuleFile (builtins.unsafeGetAttrPos "a" { a = 0; }).file;
  src  = builtins.readFile "${__scriptSrc}";

  bash-exe = "${bash}/bin/bash";
  nvr      = "${neovim-remote}/bin/nvr";
  whiptail = "${newt}/bin/whiptail";

  checkPhase = ''
    ${shellCheckers.fileIsExecutable bash-exe}
    ${shellCheckers.fileIsExecutable nvr}
    ${shellCheckers.fileIsExecutable whiptail}
  '';

  pkg = writeCheckedExecutable name checkPhase ''
    #! ${bash-exe}
    set -e || exit
    PATH=${esc neovim-remote}/bin:$PATH
    PATH=${esc newt}/bin:$PATH
    ${src}
  '';
in
assert valueCheckers.isNonEmptyString src;
pkg // { inherit checkPhase; scriptSrc = __scriptSrc; }
