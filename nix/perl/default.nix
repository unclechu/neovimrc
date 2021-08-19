# Author: Viacheslav Lotsmanov
# License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE

# This module is intended to be called with ‘nixpkgs.callPackage’
{ callPackage
, makeWrapper
, symlinkJoin
, lib

, perl
, perlPackages

# Overridable dependencies
, localPerlDependencies ? callPackage ./dependencies.nix {}

# Build options
, extraPerlDependencies ? []
}:
let
  perlDeps = [
    localPerlDependencies.NeovimExt
    perlPackages.Appcpanminus # Neovim :checkhealth reports it’s missing
    perlPackages.locallib
  ] ++ extraPerlDependencies;

  # This is a hack to have no warnings in “:checkhealth” in Neovim.
  # Obtained initially from “perl -I ~/perl5/lib/perl5/ -Mlocal::lib”.
  localLibVars = lib.splitString "\n" ''
    export PATH="''${HOME}/perl5/bin''${PATH:+:''${PATH}}"
    export PERL5LIB="''${HOME}/perl5/lib/perl5''${PERL5LIB:+:''${PERL5LIB}}"
    export PERL_LOCAL_LIB_ROOT="''${HOME}/perl5''${PERL_LOCAL_LIB_ROOT:+:''${PERL_LOCAL_LIB_ROOT}}"
    export PERL_MB_OPT="--install_base \"''${HOME}/perl5\""
    export PERL_MM_OPT="INSTALL_BASE=''${HOME}/perl5"
  '';
in
symlinkJoin {
  name = "perl-for-neovim";
  nativeBuildInputs = [ makeWrapper ];
  paths = [ perl ];
  postBuild = ''
    wrapProgram "$out"/bin/perl --prefix PERL5LIB : ${perlPackages.makeFullPerlPath perlDeps} ${
      builtins.concatStringsSep " "
        (map (x: "--run " + lib.escapeShellArg x) localLibVars)
    }
  '';
}
