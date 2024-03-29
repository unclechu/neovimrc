# Author: Viacheslav Lotsmanov
# License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE

# This module is intended to be called with ‘nixpkgs.callPackage’
{ callPackage

# Overridable Neovim itself
, neovim
, neovim-qt

# Optional dependencies (set to “null” explicitly when call “callPackage” to use global one)
, fzf ? null # Dependency for “fzf.vim”

# Overridable dependencies
, __utils ? callPackage ../utils.nix {}
, perlForNeovim ? callPackage ../perl {}

# Build options
, __neovimRC  ? __utils.cleanSource ../../.
, bashEnvFile ? null # E.g. a path to ‘.bash_aliases’ file (to make aliases be available via ‘:!…’)
, with-perl-support ? true
}:
let
  generic = callPackage ../generic.nix {
    inherit neovim fzf __utils __neovimRC bashEnvFile perlForNeovim with-perl-support;
  };

  neovim-for-gui = generic.wenzelsNeovimGeneric { forGUI = true; };
in
neovim-qt.override { neovim = neovim-for-gui; } // { inherit neovim-for-gui; }
