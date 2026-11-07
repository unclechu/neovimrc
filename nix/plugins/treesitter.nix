# Author: Viacheslav Lotsmanov
# License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE

# TreeSitter plugin with added syntax/filetype plugins for it.
#
# See https://github.com/nvim-treesitter/nvim-treesitter
# See https://tree-sitter.github.io/tree-sitter/

# This module is intended to be called with ‘nixpkgs.callPackage’
{ callPackage
, vimPlugins
}:

let
  plugin-overrides = import ../sources.nix { sourcesFile = ./sources.json; };
  tree-sitter-confetti-source = import plugin-overrides.tree-sitter-confetti;
  tree-sitter-confetti = callPackage tree-sitter-confetti-source {};
  inherit (tree-sitter-confetti) tree-sitter-confetti-grammar;

  treesitter = vimPlugins.nvim-treesitter.withPlugins (tsPlugins: [
    # Code
    tsPlugins.haskell
    tsPlugins.purescript
    tsPlugins.nim
    tsPlugins.c
    tsPlugins.cpp
    tsPlugins.javascript
    tsPlugins.typescript
    tsPlugins.tsx
    tsPlugins.supercollider
    tsPlugins.vim
    tsPlugins.glsl

    # Scripting
    tsPlugins.lua
    tsPlugins.perl
    tsPlugins.python
    tsPlugins.ruby
    tsPlugins.jq
    tsPlugins.bash

    # JVM stuff
    tsPlugins.java
    tsPlugins.kotlin
    tsPlugins.clojure

    # Lisp family
    tsPlugins.commonlisp
    tsPlugins.scheme
    tsPlugins.racket

    # Data/configuration
    tsPlugins.yaml
    tsPlugins.json
    tsPlugins.xml
    tsPlugins.diff
    tree-sitter-confetti-grammar

    # Build tools
    tsPlugins.nix
    tsPlugins.make
    tsPlugins.cmake

    # Markup
    tsPlugins.markdown
    tsPlugins.html
    tsPlugins.css

    # Queries, specs, schemas
    tsPlugins.sql
    tsPlugins.dot
    tsPlugins.dockerfile
  ]);
in

treesitter
