args@
{ pkgs ? import <nixpkgs> {}
, bashEnvFile ? null
, neovimRC ? ../../.
}:
(import ../generic.nix args).wenzelsNeovimGeneric {}
