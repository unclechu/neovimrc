let sources = import ../sources.nix; in
{ pkgs   ? import sources.nixpkgs {}
, utils  ? import ../utils.nix { inherit pkgs; }
, neovim ? import ../apps/neovim.nix { inherit pkgs; }
, origin ? ../../apps/nvimd
}:
let
  inherit (utils) nameOfModuleFile writeCheckedExecutable perlLibWrap;

  name = nameOfModuleFile (builtins.unsafeGetAttrPos "a" { a = 0; }).file;
  src  = builtins.readFile "${origin}";

  nvim  = "${neovim}/bin/nvim";
  perl = "${pkgs.perl}/bin/perl";
  pkill = "${pkgs.procps}/bin/pkill";

  checkPhase = ''
    ${utils.shellCheckers.fileIsExecutable perl}
    ${utils.shellCheckers.fileIsExecutable nvim}
    ${utils.shellCheckers.fileIsExecutable pkill}
  '';

  perlScript = writeCheckedExecutable name checkPhase ''
    #! ${perl}
    use v5.10; use strict; use warnings; use autodie qw(:all);
    $ENV{PATH} = q<${neovim}/bin:>.$ENV{PATH};
    $ENV{PATH} = q<${pkgs.procps}/bin:>.$ENV{PATH};
    ${src}
  '';

  deps = [ pkgs.perlPackages.IPCSystemSimple ];
  pkg = perlLibWrap { inherit name checkPhase deps; } perlScript;
in
assert utils.valueCheckers.isNonEmptyString src;
pkg // { inherit checkPhase; originSrc = src; perlDependencies = deps; }
