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

# Local options
, with-neovim-qt           ? false
, with-clean-vim-script    ? false
, with-git-grep-nvr-script ? false
, with-nvimd-script        ? false
}:
let
  forwardedNames = [
    "__utils"
    "__fzf"
    "__neovimRC"
    "bashEnvFile"
  ];

  filterForwarded = pkgs.lib.filterAttrs (n: v: builtins.elem n forwardedNames);

  neovim    = pkgs.callPackage nix/apps/neovim.nix    (filterForwarded args);
  neovim-qt = pkgs.callPackage nix/apps/neovim-qt.nix (filterForwarded args);

  scriptArgs = if builtins.hasAttr "__utils" args then { inherit __utils; } else {};

  clean-vim    = pkgs.callPackage nix/scripts/clean-vim.nix scriptArgs;
  git-grep-nvr = pkgs.callPackage nix/scripts/git-grep-nvr.nix scriptArgs;
  nvimd        = pkgs.callPackage nix/scripts/nvimd.nix (scriptArgs // { __neovim = neovim; });
in
pkgs.mkShell {
  buildInputs = [
    neovim
  ] ++ (
    if with-neovim-qt then [ neovim-qt ] else []
  ) ++ (
    if with-clean-vim-script then [ clean-vim ] else []
  ) ++ (
    if with-git-grep-nvr-script then [ git-grep-nvr ] else []
  ) ++ (
    if with-nvimd-script then [ nvimd ] else []
  );
}
