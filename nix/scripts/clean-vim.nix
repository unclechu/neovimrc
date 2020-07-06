{ pkgs   ? import <nixpkgs> {}
, origin ? ../../apps/clean-vim
}:
let
  utils = import ../utils.nix { inherit pkgs; };
  inherit (utils) nameOfModuleFile writeCheckedExecutable perlLibWrap;

  name = nameOfModuleFile (builtins.unsafeGetAttrPos "a" { a = 0; }).file;
  src  = builtins.readFile "${origin}";

  perl = "${pkgs.perl}/bin/perl";

  checkPhase = ''
    ${utils.shellCheckers.fileIsExecutable perl}
  '';

  perlScript = writeCheckedExecutable name checkPhase "#! ${perl}\n${src}";
  deps = [ pkgs.perlPackages.IPCSystemSimple ];
  pkg = perlLibWrap { inherit name checkPhase deps; } perlScript;
in
assert utils.valueCheckers.isNonEmptyString src;
pkg // { inherit checkPhase; originSrc = src; perlDependencies = deps; }
