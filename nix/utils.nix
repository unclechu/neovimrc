# Author: Viacheslav Lotsmanov
# License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE
let sources = import ./sources.nix; in
# This module is intended to be called with ‘nixpkgs.callPackage’
{ callPackage
, lib
, nix-gitignore
, perlPackages

# Overridable dependencies
, __nix-utils ? callPackage sources.nix-utils { inherit perlPackages; }
}:
let inherit (__nix-utils) esc wrapExecutable; in
__nix-utils // {
  exe = pkg: executable-name: "${esc pkg}/bin/${esc executable-name}";

  cleanSource =
    let
      noVimPlug = fileName: fileType: ! (
        fileType == "directory" &&
        builtins.elem (baseNameOf fileName) [ "autoload" "vim-plug" ]
      );

      noUnnecessaryFiles = fileName: fileType: ! (
        fileType == "regular" &&
        builtins.elem (baseNameOf fileName) [
          ".editorconfig"
          ".gitignore"
          ".gitmodules"
          "README.md"
          "digraphs-list.txt"
          "make.pl"
          "Makefile"
        ]
      );

      filter = fileName: fileType:
        lib.cleanSourceFilter fileName fileType &&
        noUnnecessaryFiles    fileName fileType &&
        noVimPlug             fileName fileType;
    in
      nix-gitignore.gitignoreFilterRecursiveSource filter [ ../.gitignore ];
}
