let sources = import ../sources.nix; in
args@
{ pkgs        ? import sources.nixpkgs {}
, utils       ? import ../utils.nix { inherit pkgs; }
, bashEnvFile ? null
, neovimRC    ? utils.gitignore ../../.
}:
let
  inherit (import ../generic.nix args) wenzelsNeovimGeneric;
  neovim-for-gui = wenzelsNeovimGeneric { forGUI = true; };
in
pkgs.neovim-qt.override { neovim = neovim-for-gui; }
