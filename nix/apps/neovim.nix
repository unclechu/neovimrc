let sources = import ../sources.nix; in
args@
{ pkgs        ? import sources.nixpkgs {}
, utils       ? import ../utils.nix { inherit pkgs; }
, bashEnvFile ? null
, neovimRC    ? utils.cleanSource ../../.
}:
(import ../generic.nix args).wenzelsNeovimGeneric {}
