# Author: Viacheslav Lotsmanov
# License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE

# This module is intended to be called with ‘nixpkgs.callPackage’
{ lib
, callPackage
, perl
, perlPackages

# Overridable dependencies
, mk-generic-script ? callPackage ../utils/mk-generic-script.nix {}
, executable-dependencies ? callPackage ../utils/executable-dependencies.nix {}

# Build options
, __scriptSrc ? ../../apps/clean-vim
}:

let
  e = executable-dependencies {
    perl = perl;
  };

  perlDependencies = [
    perlPackages.IPCSystemSimple
  ];

  perlDependenciesBinPath = perlPackages.makePerlPath perlDependencies;

  pkg = mk-generic-script {
    name = "clean-vim";
    src = __scriptSrc;
    inherit e;
    dontAddDependencies = true;
    cutOffRuntimeDependenciesCheckPhase = null;
    buildInputs = [ e.executables.perl ];
    lintBuildInputs = [ e.executables.perl ];
    wrapProgramArgs = [ "--set" "PERL5LIB" perlDependenciesBinPath ];

    lintPhase = ''
      (
        export PERL5LIB=${lib.escapeShellArg perlDependenciesBinPath}
        perl -c -- "$src"
      )
    '';
  };
in

pkg // { inherit perlDependencies; }
