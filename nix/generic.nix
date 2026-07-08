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
, tree-sitter

# Core Neovim dependency
, neovim-unwrapped
, wrapNeovimUnstable

# This helper was removed in later nixpkgs releases
, makeNeovim ? config: wrapNeovimUnstable neovim-unwrapped config

# --- Stuff that is not coming from the nixpkgs ---

# Overridable dependencies
, executable-dependencies ? callPackage utils/executable-dependencies.nix {}
, __cleanSource ? callPackage utils/clean-source.nix {}

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

  spell-unicode-apostrophe = callPackage ./spell-unicode-apostrophe.nix {};

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
    tree-sitter-cli = tree-sitter;
    fzf = fzf;
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

      runtimeDependencies = [
        # `:checkhealth` reports that `tree-sitter-cli` is missing
        e.executables.tree-sitter-cli

        # There is plenty of fuzzy-search stuff integrated into this config
        # which is based on FZF calls.
        e.executables.fzf

        # Git is a runtime dependency too for a few of the plugins.
        # But I rely on presence of Git in the user’s PATH.
      ];

      # A smoke test for this Neovim config.
      #
      # Relies on the key mappings in my Neovim configuration.
      # Writes some text via simulated key presses and saves it to a file.
      smokeTest = ''
        set -o errexit || exit; set -o errtrace; set -o nounset; set -o pipefail
        export PATH="$path_prefix:$PATH"

        # Plan Vimscript test
        ${smokeTestTemplate "Vimscript" (testStr: testFile: ''
          call feedkeys("i${testStr}\<Esc>;wq ${testFile}\<CR>", "mtx")
        '')}

        # Lua equivalent (test the Lua setup is healthy)
        ${smokeTestTemplate "Lua" (testStr: testFile: ''
          lua vim.api.nvim_feedkeys(vim.keycode([[i${testStr}<Esc>;wq ${testFile}<CR>]]), "mtx", false)
        '')}

        # Perl5 equivalent (test the Perl5 setup is healthy)
        ${smokeTestTemplate "Perl5" (testStr: testFile: ''
          call feedkeys(perleval("q{i${testStr}\<Esc>;wq ${testFile}\<CR>}"), "mtx")
        '')}
      '';

      smokeTestTemplate = marker: exprFn:
        let
          testStr = "Hello world from ${marker}";
          testFile = "test-output-${marker}";
          logFile = "nvim-${marker}.log";
        in
        ''
          (
            exit_code=0
            "$nvim" --headless -n -i NONE -c \
              ${esc (exprFn testStr testFile)} &>${esc logFile} || exit_code=$?

            if (( exit_code != 0 )); then
              >&2 printf 'Smoke test failed (marker: “%s”) with exit code: %d\n' \
                ${esc marker} "$exit_code"
              log=$(<${esc logFile})
              >&2 printf 'Neovim log: %s\n' "$log"
              exit "$exit_code"
            fi

            contents=$(<${esc testFile})

            if [[ "$contents" != ${esc testStr} ]]; then
              >&2 printf \
                'Vimscript smoke test failed. Test file “%s” contents: “%s”\n' \
                ${esc testFile} "$contents"
              log=$(<${esc logFile})
              >&2 printf 'Neovim log: %s\n' "$log"
              exit 1
            fi
          )
        '';

      wrap = neovim:
        symlinkJoin {
          name = "${lib.getName neovim}-wrapper";
          nativeBuildInputs = [ makeBinaryWrapper ];
          paths = [ neovim ];
          postBuild = ''
            nvim="$out"/bin/nvim
            path_prefix=${esc (lib.makeBinPath runtimeDependencies)}
            wrapProgram "$nvim" --prefix PATH : "$path_prefix"
            (${smokeTest})
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
          let &rtp .= ',${spell-unicode-apostrophe}'
          se pp-=~/.vim/after
          so ${initFiles.pre} " pre plugins init stage
          let &pp .= ',${configDir}' " postpone post plugins init stage
        '';
      });
in
{
  inherit wenzelsNeovimGeneric; # main export
  inherit rcDirGeneric init ginit initParts initFiles; # just for debug
}
