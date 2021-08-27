# Author: Viacheslav Lotsmanov
# License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE

# WARNING! Keep in mind that at the moment in stable “nixpkgs” for NixOS 21.05 Neovide just fails to
# start. So if you want it to work use Neovide from “nixpkgs-unstable”. This works for me.

# This module is intended to be called with ‘nixpkgs.callPackage’
{ callPackage
, symlinkJoin
, makeWrapper
, lib

# Overridable Neovim itself
, neovim
, neovide

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
  inherit (__utils) esc;

  generic = callPackage ../generic.nix {
    inherit neovim fzf __utils __neovimRC bashEnvFile perlForNeovim with-perl-support;
  };

  neovim-for-gui = generic.wenzelsNeovimGeneric { forGUI = true; };
in
symlinkJoin {
  name = "${lib.getName neovide}-wrapper";
  nativeBuildInputs = [ makeWrapper ];
  paths = [ neovide ];
  postBuild = ''
    wrapProgram "$out"/bin/neovide \
      --prefix PATH : ${esc (lib.makeBinPath [ neovim-for-gui ])}
  '';
} // { inherit neovim-for-gui; }
