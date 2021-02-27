let sources = import ../sources.nix; in
{ pkgs   ? import sources.nixpkgs {}
, utils  ? import ../utils.nix { inherit pkgs; }
, neovim ? import ../apps/neovim.nix { inherit pkgs; }
, origin ? ../../apps/nvimd
}:
let
  inherit (utils) nameOfModuleFile writeCheckedExecutable wrapExecutable wrapExecutableWithPerlDeps;

  name = nameOfModuleFile (builtins.unsafeGetAttrPos "a" { a = 0; }).file;
  src  = builtins.readFile "${origin}";

  perl = "${pkgs.perl}/bin/perl";
  nvim  = "${neovim}/bin/nvim";
  pkill = "${pkgs.procps}/bin/pkill";

  checkPhase = ''
    ${utils.shellCheckers.fileIsExecutable perl}
    ${utils.shellCheckers.fileIsExecutable nvim}
    ${utils.shellCheckers.fileIsExecutable pkill}
  '';

  perlScript = writeCheckedExecutable name checkPhase "#! ${perl}\n${src}";
  app = wrapExecutable "${perlScript}/bin/${name}" { deps = [ neovim pkgs.procps ]; };
  deps = p: [ p.IPCSystemSimple ];
  pkg = wrapExecutableWithPerlDeps "${app}/bin/${name}" { inherit deps; };
in
assert utils.valueCheckers.isNonEmptyString src;
pkg // { inherit checkPhase; originSrc = src; perlDependencies = deps; }
