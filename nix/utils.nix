let sources = import ./sources.nix; in
{ pkgs ? import sources.nixpkgs {}
}:
let
  utils = import sources.nix-utils { inherit pkgs; };
  inherit (utils) esc wrapExecutable;
in
utils // {
  utils-src = sources.nix-utils;
  exe = pkg: executable-name: "${esc pkg}/bin/${esc executable-name}";

  perlLibWrap = { name, checkPhase, deps }: perlScript:
    assert builtins.isString name;
    assert builtins.isString checkPhase;
    assert builtins.isList deps;
    assert builtins.all pkgs.lib.isDerivation deps;
    wrapExecutable "${perlScript}/bin/${name}" {
      env = { PERL5LIB = pkgs.perlPackages.makePerlPath deps; };
      inherit checkPhase;
    };
}
