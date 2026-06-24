# Author: Viacheslav Lotsmanov
# License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE

# This module is intended to be called with ‘nixpkgs.callPackage’
{ lib
, nix-gitignore

, __gitignoreFiles ? [ ../../.gitignore ]
}:

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

nix-gitignore.gitignoreFilterRecursiveSource filter __gitignoreFiles
