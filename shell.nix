# Author: Viacheslav Lotsmanov
# License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE
let sources = import nix/sources.nix; in
args@
{ pkgs ? import sources.nixpkgs {}

# Forwarded arguments.
# See ‘nix/generic.nix’ for details.
, __neovimRC ? null
, bashEnvFile ? null
, __permitPluginsLackingLicenseInformation ? null
, mk-generic-script ? pkgs.callPackage utils/mk-generic-script.nix {}
, executable-dependencies ? pkgs.callPackage utils/executable-dependencies.nix {}
, __cleanSource ? pkgs.callPackage utils/clean-source.nix {}

, perlForNeovim ? pkgs.callPackage nix/perl {}

# Local options
, with-neovim-qt           ? false
, with-neovide             ? false
, with-clean-vim-script    ? false
, with-git-grep-nvr-script ? false
, with-nvimd-script        ? false
, with-perl-support        ? true
}:
let
  inherit (pkgs) lib callPackage;

  forwardedNames = [
    "__neovimRC"
    "bashEnvFile"
    "__permitPluginsLackingLicenseInformation"
    "executable-dependencies"
    "__cleanSource"
    "perlForNeovim"
    "with-perl-support"
  ];

  filterForwarded = lib.filterAttrs (n: v: builtins.elem n forwardedNames);
  fwdArgs = filterForwarded args;

  neovim = callPackage nix/apps/neovim.nix fwdArgs;
  neovim-qt = callPackage nix/apps/neovim-qt.nix fwdArgs;
  neovide = callPackage nix/apps/neovide.nix fwdArgs;

  scriptArgs =
    lib.filterAttrs (n: v: builtins.elem n [
      "mk-generic-script"
      "executable-dependencies"
    ]) args;

  clean-vim = callPackage nix/scripts/clean-vim.nix scriptArgs;
  git-grep-nvr = callPackage nix/scripts/git-grep-nvr.nix scriptArgs;
  nvimd = callPackage nix/scripts/nvimd.nix (scriptArgs // { __neovim = neovim; });
in
pkgs.mkShell {
  buildInputs =
    [ neovim ]
    ++ (lib.optional with-neovim-qt           neovim-qt)
    ++ (lib.optional with-neovide             neovide)
    ++ (lib.optional with-clean-vim-script    clean-vim)
    ++ (lib.optional with-git-grep-nvr-script git-grep-nvr)
    ++ (lib.optional with-nvimd-script        nvimd)
    ++ (lib.optional with-perl-support        perlForNeovim);
}
