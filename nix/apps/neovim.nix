let sources = import ../sources.nix; in
args@
{ pkgs        ? import sources.nixpkgs {}
, bashEnvFile ? null
, neovimRC    ? ../../.
}:
(import ../generic.nix args).wenzelsNeovimGeneric {}
