# Author: Viacheslav Lotsmanov
# License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE
let sources = import ./sources.nix; in
# This module is intended to be called with ‘nixpkgs.callPackage’
{ callPackage
, runCommand
, writeText
, symlinkJoin
, makeBinaryWrapper
, config
, lib
, coreutils
, fzf
, perl

# Core Neovim dependency
, neovim-unwrapped
, wrapNeovimUnstable

# This helper was removed in later nixpkgs releases
, makeNeovim ? config: wrapNeovimUnstable neovim-unwrapped config

# --- Stuff that is not coming from the nixpkgs ---

# Overridable dependencies
, executable-dependencies ? callPackage utils/executable-dependencies.nix {}
, __cleanSource ? callPackage utils/clean-source.nix {}
, perlForNeovim ? callPackage ./perl {}

# Build options
, __neovimRC  ? __cleanSource ../.
, bashEnvFile ? null # E.g. a path to ‘.bash_aliases’ file (to make aliases be available via ‘:!…’)
, with-perl-support ? true
# Some plugins used in this configuration are marked as “unfree” because they
# are lacking license information. This flag allows to permit those packages by
# overriding the license with Public Domain.
, __permitPluginsLackingLicenseInformation ? false
}:

let
  plugins = callPackage ./plugins.nix {
    inherit
      __cleanSource
      executable-dependencies
      __neovimRC
      __permitPluginsLackingLicenseInformation;
  };

  rcDerivation = "${__neovimRC}";

  rcDirName = "wenzels-neovim";
  rcDirNameForGUI = "${rcDirName}-for-gui";

  init  = builtins.readFile "${rcDerivation}/init.vim";
  ginit = builtins.readFile "${rcDerivation}/ginit.vim";

  initParts =
    let
      isPluginsImport = x: builtins.match ".*so.*'/plugins.vim'" x != null;

      handleLine = line:
        if builtins.match "^let \\$BASH_ENV =.*" line != null
        then (
          if isNull bashEnvFile
          then ""
          else "let $BASH_ENV = '${bashEnvFile}'"
        )
        else line;

      reducer = acc: line: acc // (
        if isPluginsImport line
        then { sep = true; pre = acc.pre ++ [""]; } # last EOL at EOF
        else if acc.sep
             then { post = acc.post ++ [(handleLine line)]; }
             else { pre  = acc.pre  ++ [(handleLine line)]; }
      );
    in
      lib.pipe init [
        (lib.splitString "\n")
        (builtins.foldl' reducer { sep = false; pre = []; post = []; })
        (lib.filterAttrs (n: _: n != "sep"))
        (builtins.mapAttrs (_: v: builtins.concatStringsSep "\n" v))
      ];

  initFiles = {
    pre  = writeText "pre-plugins-init.vim"  (initParts.pre);
    post = writeText "post-plugins-init.vim" (initParts.post);

    postForGui = writeText "post-plugins-init-for-gui.vim" ''
      ${initParts.post}
      ${ginit}
    '';
  };

  esc = lib.escapeShellArg;

  e = executable-dependencies {
    mkdir = coreutils;
    cp = coreutils;
  };

  rcDirGeneric = { forGUI ? false }:
    assert builtins.isBool forGUI;
    let
      fullInitFile = writeText "init.vim" ''
        ${initParts.pre}
        ${initParts.post}
        ${if forGUI then ginit else ""}
      '';

      postFile = if forGUI then initFiles.postForGui else initFiles.post;
    in
      runCommand (if forGUI then rcDirNameForGUI else rcDirName) {} ''
        set -Eeuo pipefail || exit
        ${e.s.mkdir} -- "$out"
        ${e.s.cp} -r -- ${esc rcDerivation}/{UltiSnips,my-modules,lua}/ "$out"
        ${e.s.cp} -r -- \
          ${esc rcDerivation}/{maps,options,plugins-configs,ginit}.vim "$out"

        # store original init.vim as one piece, it's linked to in $MYVIMRC
        # which is also used by config reloading hotkey.
        ${e.s.cp} -- ${esc fullInitFile} "$out"/${esc fullInitFile.name}

        echo > "$out/plugins.vim" # just a dummy plug

        # for post-pluings part of the init.vim being interpreted as a package (latest in the order)
        ${e.s.mkdir} -- "$out/plugin"
        ${e.s.cp} -- ${esc postFile} "$out/plugin/"${esc postFile.name}
      '';

  wenzelsNeovimGeneric = { forGUI ? false }:
    assert builtins.isBool forGUI;
    let
      configDir = rcDirGeneric { inherit forGUI; };

      wrap = neovim:
        symlinkJoin {
          name = "${lib.getName neovim}-wrapper";
          nativeBuildInputs = [ makeBinaryWrapper ];
          paths = [ neovim ];
          postBuild = ''
            nvim="$out"/bin/nvim
            wrapProgram "$out"/bin/nvim --prefix PATH : ${esc (lib.makeBinPath [fzf])}

            # Smoke test
            (
              set -o nounset

              # FIXME: The test is bypassed. When updating 24.05 → 24.11 the test was failing for
              # some reason while when I try to run it as a command in a terminal it works just
              # fine. Maybe new 0.10.* Neovim makes a hard dependency on TTY or something.
              exit 0

              # Relies on the key mappings in my Neovim configuration
              "$nvim" --cmd 'lua vim.api.nvim_input("ihello world<esc>;wq test<cr>")' 0<&- &>/dev/null

              # There must be “test” file created by the previous command
              contents=$(cat test)

              if [[ $contents != 'hello world' ]]; then
                >&2 printf 'Smoke test failed. Test file contents: "%s"\n' "$contents"
                exit 1
              fi
            )
          '';
        };
    in
      wrap (makeNeovim {
        withNodeJs = false;
        withRuby = false;

        withPython3 = true; # Python is required for example for UltiSnips
        withPerl = assert builtins.isBool with-perl-support; with-perl-support;

        plugins = map (p: { plugin = p; }) (plugins.own ++ plugins.other);

        neovimRcContent = ''
          let $MYVIMRC = '${configDir}/init.vim'
          let &rtp .= ',${configDir}' " for UltiSnips
          se pp-=~/.vim/after
          so ${initFiles.pre} " pre plugins init stage
          let &pp .= ',${configDir}' " postpone post plugins init stage
        '';
      } // (
        if ! with-perl-support then {} else { perlEnv = perlForNeovim; }
      ));
in
{
  inherit wenzelsNeovimGeneric; # main export
  inherit rcDirGeneric init ginit initParts initFiles; # just for debug
}
