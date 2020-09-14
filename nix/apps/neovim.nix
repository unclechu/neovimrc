args@
{ pkgs ? import ../default-nixpkgs-pick.nix
, bashEnvFile ? null
, neovimRC ? ../../.
}:
(import ../generic.nix args).wenzelsNeovimGeneric {}
