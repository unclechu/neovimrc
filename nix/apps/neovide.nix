# Author: Viacheslav Lotsmanov
# License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE

# WARNING! Keep in mind that at the moment in stable “nixpkgs” for NixOS 21.05 Neovide just fails to
# start. So if you want it to work use Neovide from “nixpkgs-unstable”. This works for me.

# This module is intended to be called with ‘nixpkgs.callPackage’
{ lib
, callPackage
, symlinkJoin
, makeBinaryWrapper

# Overridable Neovim
, neovim-unwrapped
, wrapNeovimUnstable
, neovide

# Overridable dependencies
, executable-dependencies ? callPackage ../utils/executable-dependencies.nix {}
, __cleanSource ? callPackage ../utils/clean-source.nix {}

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

      __neovimRC
      bashEnvFile
      with-perl-support
      __permitPluginsLackingLicenseInformation
      ;
  };

  neovim-for-gui = generic.wenzelsNeovimGeneric { forGUI = true; };
in

symlinkJoin {
  name = "${lib.getName neovide}-wrapper";
  nativeBuildInputs = [ makeBinaryWrapper ];
  paths = [ neovide ];
  postBuild = ''
    wrapProgram "$out"/bin/neovide \
      --prefix PATH : ${lib.escapeShellArg (lib.makeBinPath [ neovim-for-gui ])} \
      --set-default NEOVIDE_MULTIGRID 1
  '';
} // { inherit neovim-for-gui; }
