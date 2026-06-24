# DO NOT MODIFY!
# This file is an automatic copy from:
# https://github.com/unclechu/nixos-config/blob/38682e0456a370ecb52e64e320ab0c4bba483cea/utils/executable-dependencies.nix
# The file copied using “cp-from-nixos-config.sh” script.

# ——————————————————————————————————————————————————————————————————————————————

# Author: Viacheslav Lotsmanov
# License: MIT https://raw.githubusercontent.com/unclechu/nixos-config/master/LICENSE

{ lib }:

# Get executable dependencies interface.
#
# It helps to reduce boilerplate a lot, reduce sources of truth, and check
# everything in build-time, reducing “missing dependency” errors in runtime.
#
# It works both for native scripts as-is (e.g. `./script.sh`) extracting
# dependencies from the code and attaching them to the derivation, and for
# interpolating executables into Nix strings (e.g. phases, `buildPhase`).
#
# `executablesMap` value example:
#
#   {
#     grep = pkgs.gnugrep;
#     cut = pkgs.coreutils;
#     diff = pkgs.diffutils;
#   };
#
executablesMap: lib.makeExtensible (final: {
  # Just forwarding the map just in case.
  executables = executablesMap;

  # Full bin paths to the executables.
  # Executable name = Full absolute path to the executable.
  #
  # Exmaples:
  #
  #   e.b.ls
  #   # Returns: "/nix/store/…-coreutils-…/bin/ls"
  #
  #   e.b.grep
  #   # Returns: "/nix/store/…-gnugrep-…/bin/grep"
  #
  # Type ∷ { string = string; }
  b = builtins.mapAttrs (n: v: lib.getExe' executablesMap.${n} n) executablesMap;

  # Shell-escaped bin paths to the executables (`b` but with escaped paths).
  #
  # So you can interpolate these values directly in your script. Like so:
  #
  #   ''
  #     ${e.s.ls} -lah | ${e.s.grep} foo
  #   ''
  #
  # It will result into something like:
  #
  #   ''
  #     '/nix/store/…-coreutils-…/bin/ls' -lah | '/nix/store/…-gnugrep-…/bin/grep' foo
  #   ''
  #
  # But if there are no spaces or any special symbols `lib.escapeShellArg` won’t
  # actually add the quotation marks, as long as the string is safe to
  # interpolate as-is.
  #
  # Type ∷ { string = string; }
  s = builtins.mapAttrs (n: v: lib.escapeShellArg v) final.b;

  # A check phase for all of the executables from `executablesMap`.
  #
  # Will ensure all bin paths exist and have an executable permission.
  #
  # Type ∷ string
  checkPhase =
    builtins.concatStringsSep "\n" (
      map (x: ">/dev/null type -- ${x}") (builtins.attrValues final.s)
    );

  # Get shell script executable dependencies list (executable names).
  #
  # It depends on a common pattern in the script that I use everywhere:
  #
  #   # Guard dependencies
  #   >/dev/null type grep
  #   >/dev/null type cut
  #   >/dev/null type diff
  #
  # For example (assuming above example as part of the `./script.sh`):
  #
  #   scriptDependencies ./script.sh
  #   # Returns: ["grep", "cut", "diff"]
  #
  # Type ∷ path → [string]
  scriptDependencies = scriptSrc:
    final.dependencies
      "^# Guard dependencies$"
      # Allow comments at the end of line
      "^>/dev/null type ([^[:space:]]+)([[:space:]]*[#].*)?$"
      scriptSrc;

  # Generic executable dependencies list extraction.
  #
  # Uses `dependenciesStartRegex` to check if dependencies list start after the
  # line matching this regular expression. Then for each next line it tries to
  # match `dependencyLineRegex` and extract the dependency name from the group.
  # If `dependencyLineRegex` does not match it stops collecting dependencies.
  #
  # Type ∷ string → string → path → [string]
  dependencies =
    dependenciesStartRegex:
    dependencyLineRegex:
    scriptSrc:
      lib.pipe scriptSrc [
        builtins.readFile
        (lib.splitString "\n")
        (builtins.foldl' (
          acc: line:
            if builtins.isAttrs acc then acc else
            if acc != null then (
              if builtins.isList acc then (
                let match = builtins.match dependencyLineRegex line; in
                if isNull match then { result = acc; } else acc ++ [(builtins.elemAt match 0)]
              ) else acc
            ) else if builtins.match dependenciesStartRegex line != null then [] else acc
        ) null)
        (x: assert builtins.isAttrs x; x)
        (x: assert builtins.length x.result > 0; x.result)
      ];

  # Convert script dependencies list to a list of derivations (unique list).
  #
  # For example:
  #
  #   # Assuming your `executablesMap` is:
  #   {
  #     grep = pkgs.gnugrep;
  #     cut = pkgs.coreutils;
  #     diff = pkgs.diffutils;
  #     rm = pkgs.coreutils;
  #   }
  #
  #   scriptDependenciesToDerivations ["grep", "cut", "diff", "rm"]
  #   # Returns: [pkgs.gnugrep pkgs.coreutils pkgs.diffutils]
  #   # Note that the list is unique, both `cut` and `rm` are coming
  #   # from `coreutils` but it appears in the resulting list only once.
  #
  # Type ∷ [string] → [derivation]
  scriptDependenciesToDerivations = dependencies:
    lib.pipe dependencies [
      (map (x: executablesMap.${x}))
      lib.unique
    ];

  # Make combined bin-path (suitable for PATH) of script’s dependencies.
  #
  # For example:
  #
  # In your script:
  #
  #   # Guard dependencies
  #   >/dev/null type grep
  #   >/dev/null type cut
  #   >/dev/null type diff
  #
  # Then for example in `installPhase`:
  #
  #   ''
  #     wrapProgram "$out/bin/script" \
  #       --prefix PATH : ${scriptDependenciesBinPath ./script.sh}
  #   ''
  #
  # Type ∷ path → string
  scriptDependenciesBinPath =
    scriptSrc: final.scriptDependenciesBinPathWithIgnore scriptSrc [];

  # `scriptDependenciesBinPath` but allowing to ignore some dependencies.
  #
  # Some dependencies must come from system dependencies, not directly from nixpkgs.
  # Like “sudo” or any root-sticky-bit ones. So those can be just ignored.
  #
  # Type ∷ [string] → path → string
  scriptDependenciesBinPathWithIgnore = scriptSrc: ignoreDeps:
    lib.pipe scriptSrc [
      final.scriptDependencies
      (builtins.filter (x: ! builtins.elem x ignoreDeps))
      final.scriptDependenciesToDerivations
      lib.makeBinPath
    ];
})
