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

  cleanSource =
    let filter = pkgs.lib.cleanSourceFilter;
     in pkgs.nix-gitignore.gitignoreFilterRecursiveSource filter [ ../.gitignore ];
}
