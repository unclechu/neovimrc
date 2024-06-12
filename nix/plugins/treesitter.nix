# Author: Viacheslav Lotsmanov
# License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE

# TreeSitter plugin with added syntax/filetype plugins for it.
#
# See https://github.com/nvim-treesitter/nvim-treesitter
# See https://tree-sitter.github.io/tree-sitter/

# This module is intended to be called with ‘nixpkgs.callPackage’
{ vimPlugins
}:

let
  treesitter = vimPlugins.nvim-treesitter.withPlugins (tsPlugins: [
    tsPlugins.haskell
    tsPlugins.purescript

    tsPlugins.lua
    tsPlugins.perl
    tsPlugins.python
    tsPlugins.ruby

    tsPlugins.java
    tsPlugins.clojure
    tsPlugins.kotlin

    tsPlugins.yaml
    tsPlugins.json
    tsPlugins.jq
    tsPlugins.xml

    tsPlugins.bash

    # Not really useful, only “diff” command and commit hashes are highlighted.
    # The most important stuff to have highlighted is additions and deletions.
    # By not adding it here making Neovim to use the non-treesitter syntax.
    # tsPlugins.diff

    tsPlugins.make
    tsPlugins.cmake

    tsPlugins.c
    tsPlugins.cpp

    tsPlugins.html
    tsPlugins.css
    tsPlugins.javascript
    tsPlugins.typescript
    tsPlugins.tsx

    tsPlugins.supercollider

    # Etc
    tsPlugins.vim
    tsPlugins.nix
    tsPlugins.sql
    tsPlugins.glsl
    tsPlugins.dot
    tsPlugins.dockerfile

    # After “nixpkgs” from 23.11 → 24.05 something became off with this syntax
    # implementation. Almost nothing is highlighted. I only see a couple colons
    # colored differently in one big document.
    # tsPlugins.markdown
  ]);
in

treesitter
