# Author: Viacheslav Lotsmanov
# License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE

# This module is intended to be called with ‘nixpkgs.callPackage’
{ lib
, callPackage
, coreutils
, procps
, perl
, perlPackages

# Overridable dependencies
, executable-dependencies ? callPackage ../utils/executable-dependencies.nix {}
, mk-generic-script ? callPackage ../utils/mk-generic-script.nix {}
# ↓ You can set it to `nixpkgs.pkgs.neovim` to test the script as standalone
, __neovim ? callPackage ../apps/neovim.nix {}

# Build options
, __scriptSrc ? ../../apps/nvimd
}:
let
  e = (executable-dependencies {
    perl = perl;
    env = coreutils;
    pkill = procps;
    nvim = __neovim;
  }).extend (final: prev: {
    scriptDependencies = scriptSrc:
      final.dependencies
        "^BEGIN [{] # Guard dependencies$"
        "^[[:space:]]*need_exe '([^']+)';([[:space:]]*#.*)?$"
        scriptSrc;
  });

  perlDependencies = [
    perlPackages.IPCSystemSimple
  ];

  perlDependenciesBinPath = perlPackages.makePerlPath perlDependencies;

  pkg = mk-generic-script {
    name = "nvimd";
    src = __scriptSrc;
    inherit e;
    buildInputs = [ e.executables.perl ];
    lintBuildInputs = [ e.executables.perl ];
    wrapProgramArgs = [ "--set" "PERL5LIB" perlDependenciesBinPath ];

    cutOffRuntimeDependenciesCheckPhase = ''
      SED_CMD=(
        sed -i
        -e '/^BEGIN { # Guard dependencies/,/^}$/d'
        -e '/^use IPC::Cmd qw(can_run)/d'
        -e '/^sub need_exe/d'
        -- "$src"
      )
      "''${SED_CMD[@]}"
    '';

    lintPhase = ''
      (
        export PERL5LIB=${lib.escapeShellArg perlDependenciesBinPath}
        (
          export PATH=${lib.escapeShellArg (e.scriptDependenciesBinPath __scriptSrc)}:$PATH
          perl -c -- "$pre_patched_src"
        )
        perl -c -- "$src"
      )
    '';
  };
in

pkg // { inherit perlDependencies; }
