# Author: Viacheslav Lotsmanov
# License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE

# This module is intended to be called with ‘nixpkgs.callPackage’
{ callPackage

# Overridable Neovim
, neovim-unwrapped
, wrapNeovimUnstable

# Overridable dependencies
, executable-dependencies ? callPackage ../utils/executable-dependencies.nix {}
, __cleanSource ? callPackage ../utils/clean-source.nix {}
, perlForNeovim ? callPackage ../perl {}

# Build options
, __neovimRC  ? __cleanSource ../../.
, bashEnvFile ? null # E.g. a path to ‘.bash_aliases’ file (to make aliases be available via ‘:!…’)
, with-perl-support ? true
# Some plugins used in this configuration are marked as “unfree” because they
# are lacking license information. This flag allows to permit those packages by
# overriding the license with Public Domain.
, __permitPluginsLackingLicenseInformation ? false
}:

let
  generic = callPackage ../generic.nix {
    inherit
      neovim-unwrapped
      wrapNeovimUnstable

      executable-dependencies
      __cleanSource
      perlForNeovim

      __neovimRC
      bashEnvFile
      with-perl-support
      __permitPluginsLackingLicenseInformation
      ;
  };
in

generic.wenzelsNeovimGeneric {}
