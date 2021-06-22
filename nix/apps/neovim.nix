# Author: Viacheslav Lotsmanov
# License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE

# This module is intended to be called with ‘nixpkgs.callPackage’
{ callPackage
, config

# Optional dependencies (set to “null” explicitly when call “callPackage” to use global one)
, fzf ? null # Dependency for “fzf.vim”

# Overridable dependencies
, __utils ? callPackage ../utils.nix {}

# Build options
, __neovimRC  ? __utils.cleanSource ../../.
, bashEnvFile ? null # E.g. a path to ‘.bash_aliases’ file (to make aliases be available via ‘:!…’)
}:
let
  generic = callPackage ../generic.nix { inherit fzf __utils __neovimRC bashEnvFile; };
in
generic.wenzelsNeovimGeneric {}
