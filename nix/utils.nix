{ pkgs ? import <nixpkgs> {}
}:
let
  utils-src = fetchGit {
    url = "https://github.com/unclechu/nix-utils.git";
    rev = "8fbdc3c63404b58275b468aaf508d5c7c198fc4b"; # 17 June 2020
    ref = "master";
  };

  utils = import utils-src { inherit pkgs; };
  inherit (utils) wrapExecutable;
in
utils // {
  inherit utils-src;

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
