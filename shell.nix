# Author: Viacheslav Lotsmanov
# License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE
let sources = import nix/sources.nix; in
args@
{ pkgs ? import sources.nixpkgs {}

# Forwarded arguments.
# See ‘nix/generic.nix’ for details.
, __utils     ? null
, __fzf       ? null
, __neovimRC  ? null
, bashEnvFile ? null

, perlForNeovim ? pkgs.callPackage nix/perl {}

# Local options
, with-neovim-qt           ? false
, with-clean-vim-script    ? false
, with-git-grep-nvr-script ? false
, with-nvimd-script        ? false
, with-perl-support        ? true
}:
let
  inherit (pkgs) lib callPackage;

  forwardedNames = [
    "__utils"
    "__fzf"
    "__neovimRC"
    "bashEnvFile"
    "perlForNeovim"
    "with-perl-support"
  ];

  filterForwarded = lib.filterAttrs (n: v: builtins.elem n forwardedNames);

  neovim    = callPackage nix/apps/neovim.nix    (filterForwarded args);
  neovim-qt = callPackage nix/apps/neovim-qt.nix (filterForwarded args);

  scriptArgs = if builtins.hasAttr "__utils" args then { inherit __utils; } else {};

  clean-vim    = callPackage nix/scripts/clean-vim.nix scriptArgs;
  git-grep-nvr = callPackage nix/scripts/git-grep-nvr.nix scriptArgs;
  nvimd        = callPackage nix/scripts/nvimd.nix (scriptArgs // { __neovim = neovim; });
in
pkgs.mkShell {
  buildInputs =
    [ neovim ]
    ++ (lib.optional with-neovim-qt           neovim-qt)
    ++ (lib.optional with-clean-vim-script    clean-vim)
    ++ (lib.optional with-git-grep-nvr-script git-grep-nvr)
    ++ (lib.optional with-nvimd-script        nvimd)
    ++ (lib.optional with-perl-support        perlForNeovim);
}
