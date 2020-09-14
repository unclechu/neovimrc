{ pkgs ? import ./default-nixpkgs-pick.nix
}:
let
  utils-src = pkgs.fetchFromGitHub {
    owner = "unclechu";
    repo = "nix-utils";
    rev = "377b3b35a50d482b9968d8d19bcb98cc4c37d6bd"; # ref "master", 9 July 2020
    sha256 = "1cikgl25a0x497v3hc7yxri2jbdm6cn7ld891ak7fhxrdb6bmlpl";
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
