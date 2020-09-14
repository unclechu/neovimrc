args@
{ pkgs ? import ../default-nixpkgs-pick.nix
, bashEnvFile ? null
, neovimRC ? ../../.
}:
let
  inherit (import ../generic.nix args) wenzelsNeovimGeneric;
  neovim-for-gui = wenzelsNeovimGeneric { forGUI = true; };
in
pkgs.neovim-qt.override { neovim = neovim-for-gui; }
