let default-fzf = import ../default-fzf.nix; in
# This module is intended to be called with ‘nixpkgs.callPackage’
{ callPackage
, config
, neovim-qt

# Overridable dependencies
, __utils ? callPackage ../utils.nix {}
, __fzf   ? default-fzf config # Set to “null” if you want to use global version

# Build options
, __neovimRC  ? __utils.cleanSource ../../.
, bashEnvFile ? null # E.g. a path to ‘.bash_aliases’ file (to make aliases be available via ‘:!…’)
}:
let
  generic = callPackage ../generic.nix (
    { inherit __utils __neovimRC bashEnvFile; } //
    (if isNull __fzf then {} else { inherit __fzf; })
  );

  neovim-for-gui = generic.wenzelsNeovimGeneric { forGUI = true; };
in
neovim-qt.override { neovim = neovim-for-gui; } // { inherit neovim-for-gui; }
