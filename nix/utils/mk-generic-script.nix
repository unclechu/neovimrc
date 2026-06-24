# DO NOT MODIFY!
# This file is an automatic copy from:
# https://github.com/unclechu/nixos-config/blob/80d3f5d895fbdc3c06dd37b512ceada7d50be937/utils/mk-generic-script.nix
# The file copied using “cp-from-nixos-config.sh” script.

# ——————————————————————————————————————————————————————————————————————————————

# Author: Viacheslav Lotsmanov
# License: MIT https://raw.githubusercontent.com/unclechu/nixos-config/master/LICENSE

{ lib
, stdenvNoCC
, makeBinaryWrapper
, shellcheck
}:

# Create a derivation for a script with all the common boilerplate I typically need.
#
# For instance is supports “executable-dependencies.nix", automatically adding
# the `checkPhase`, extracting dependencies from the script, and attaching them
# to the PATH for the script wrapper. It also automatically cuts off the
# runtime dependencies checking (since they are already checked in build time).
# If your script requires a dependency (usually set by `# Guard dependencies`
# block) but it is not found in the list of executables you provided for
# `executable-dependencies` you’ll get a build failure. So your native plan Bash
# code is a source of truth. Only the dependencies your script explicitly
# specifies will be added to the script wrapper PATH, so you should not worry
# about adding build-time dependencies to `executable-dependencies`.
#
# This function also automatically adds linting (ShellCheck by default).
#
# It accepts `wrapProgramArgs` adding the arguments to the `wrapProgram` call,
# but `wrapProgramArgs` a Nix list of strings that will automatically be escaped
# for shell, so it’s more convenient to use.
#
# Everything is customizable. You can use whatever programming/scripting
# language.
#
# Usage example for a simple shell script:
#
#   let
#     e = executable-dependencies {
#       inotifywait = inotify-tools;
#       sed = gnused;
#       dzen2 = dzen2;
#       rm = coreutils;
#       stat = coreutils;
#       sleep = coreutils;
#       head = coreutils;
#       touch = coreutils;
#     };
#   in
#
#   mk-generic-script {
#     name = "dzen-box";
#     src = ./dzen-box.sh;
#     inherit e;
#   }
#
args@
{ name # string
, src # path

, nativeBuildInputs ? [] # [derivation]
, checkPhase ? null # string

, lintBuildInputs ? [
    shellcheck
  ]
, lintPhase ? ''
    shellcheck -- "$pre_patched_src"
    shellcheck -- "$src" # Check that after patching nothing is broken
  ''

, cutOffRuntimeDependenciesCheckPhase ? ''
    # Dependencies are pre-checked.
    # No need to spend time on always checking them in runtime.
    sed -i '/# Guard dependencies/,/^$/d' "$src"
  ''

, postPatch ? null

, dontAddDependencies ? false # boolean

# [string | {raw=string}]
# {raw=string} for unescaped shell expression, just in case you ever need it.
, wrapProgramArgs ? []

# string
, installPhase ? ''
    BIN_PATH="$out/bin/"${lib.escapeShellArg name}
    install -Dm755 -- "$src" "$BIN_PATH"
    ${lib.optionalString (
      builtins.length wrapProgramArgs > 0 ||
      (!dontAddDependencies && e != null)
    ) (
      let
        addDependencies =
          lib.optionals (!dontAddDependencies && e != null) [
            "--prefix" "PATH" ":" (e.scriptDependenciesBinPath src)
          ];
      in
        ''
          wrapProgram "$BIN_PATH" ${
            lib.pipe (addDependencies ++ wrapProgramArgs) [
              (map (x:
                if builtins.isString x || builtins.isPath x || lib.isDerivation x
                then lib.escapeShellArg "${x}"
                else assert builtins.isString x.raw; x.raw
              ))
              (builtins.concatStringsSep " ")
            ]
          }
        ''
    )}
  ''

# An instance of `executable-dependencies.nix`.
# Set explicitly to `null` if you don’t provide it.
# Makes it easier to notice without a default value if you just forget to add it.
, e

, ...
}:

assert builtins.hasAttr "installPhase" args ->
  # `dontAddDependencies` has no meaning if `installPhase` is overridden
  (! builtins.hasAttr "dontAddDependencies" args)
  && builtins.isString installPhase
  ;

assert builtins.isString name;
assert ! isNull checkPhase -> builtins.isString checkPhase;

# These are not expected to be overridden
assert ! builtins.hasAttr "dontUnpack" args;
assert ! builtins.hasAttr "doCheck" args;

stdenvNoCC.mkDerivation (builtins.removeAttrs args [
  "nativeBuildInputs"
  "checkPhase"
  "installPhase"
  "postPatch"
  "e"
] // {
  meta.mainProgram = name;

  nativeBuildInputs = [
    makeBinaryWrapper
  ] ++ (
    lib.optionals (! isNull lintPhase) lintBuildInputs
  ) ++ nativeBuildInputs;

  dontUnpack = true;
  doCheck = true;

  checkPhase = ''
    runHook preCheck
    ${lib.optionalString (! isNull lintPhase) lintPhase}
    ${lib.optionalString (! isNull e) e.checkPhase}
    ${lib.optionalString (! isNull checkPhase) checkPhase}
    runHook postCheck
  '';

  postPatch = ''
    pre_patched_src=$src
    cp -- "$src" "''${src##*/}"
    src="''${src##*/}"

    ${
      lib.optionalString
        (! isNull cutOffRuntimeDependenciesCheckPhase)
        cutOffRuntimeDependenciesCheckPhase
    }

    ${lib.optionalString (! isNull postPatch) postPatch}
  '';

  installPhase = ''
    runHook preInstall
    ${installPhase}
    runHook postInstall
  '';
})
