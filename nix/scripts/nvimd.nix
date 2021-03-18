# This module is intended to be called with ‘nixpkgs.callPackage’
{ callPackage
, procps
, perl
, perlPackages

# Overridable dependencies
, __utils  ? callPackage ../utils.nix { inherit perlPackages; }
, __neovim ? callPackage ../apps/neovim.nix { inherit __utils; }

# Build options
, __scriptSrc ? ../../apps/nvimd
}:
let
  inherit (__utils)
    nameOfModuleFile writeCheckedExecutable wrapExecutable wrapExecutableWithPerlDeps
    shellCheckers valueCheckers;

  name = nameOfModuleFile (builtins.unsafeGetAttrPos "a" { a = 0; }).file;
  src  = builtins.readFile "${__scriptSrc}";

  perl-exe = "${perl}/bin/perl";
  nvim     = "${__neovim}/bin/nvim";
  pkill    = "${procps}/bin/pkill";

  checkPhase = ''
    ${shellCheckers.fileIsExecutable perl-exe}
    ${shellCheckers.fileIsExecutable nvim}
    ${shellCheckers.fileIsExecutable pkill}
  '';

  perlScript = writeCheckedExecutable name checkPhase "#! ${perl-exe}\n${src}";
  app = wrapExecutable "${perlScript}/bin/${name}" { deps = [ __neovim procps ]; };
  deps = p: [ p.IPCSystemSimple ];
  pkg = wrapExecutableWithPerlDeps "${app}/bin/${name}" { inherit deps; };
in
assert valueCheckers.isNonEmptyString src;
pkg // {
  inherit checkPhase;
  perlDependencies = deps perlPackages;
  scriptSrc = __scriptSrc;
}
