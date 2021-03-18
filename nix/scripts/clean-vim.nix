# This module is intended to be called with ‘nixpkgs.callPackage’
{ callPackage
, perl
, perlPackages

# Overridable dependencies
, __utils ? callPackage ../utils.nix { inherit perlPackages; }

# Build options
, __scriptSrc ? ../../apps/clean-vim
}:
let
  inherit (__utils)
    nameOfModuleFile writeCheckedExecutable wrapExecutableWithPerlDeps
    shellCheckers valueCheckers;

  name = nameOfModuleFile (builtins.unsafeGetAttrPos "a" { a = 0; }).file;
  src  = builtins.readFile "${__scriptSrc}";

  perl-exe = "${perl}/bin/perl";

  checkPhase = ''
    ${shellCheckers.fileIsExecutable perl-exe}
  '';

  perlScript = writeCheckedExecutable name checkPhase "#! ${perl-exe}\n${src}";
  deps = p: [ p.IPCSystemSimple ];
  pkg = wrapExecutableWithPerlDeps "${perlScript}/bin/${name}" { inherit deps; };
in
assert valueCheckers.isNonEmptyString src;
pkg // {
  inherit checkPhase;
  perlDependencies = deps perlPackages;
  scriptSrc = __scriptSrc;
}
