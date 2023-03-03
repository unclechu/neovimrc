# Author: Viacheslav Lotsmanov
# License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE
let sources = import ./sources.nix; in
# This module is intended to be called with ‘nixpkgs.callPackage’
{ callPackage
, runCommand
, writeText
, symlinkJoin
, makeWrapper
, config
, lib
, coreutils

# Overridable Neovim itself
, neovim

# Optional dependencies (set to “null” explicitly when call “callPackage” to use global one)
, fzf ? null # Dependency for “fzf.vim”

# Overridable dependencies
, __utils ? callPackage ./utils.nix {}
, perlForNeovim ? callPackage ./perl {}

# Build options
, __neovimRC  ? __utils.cleanSource ../.
, bashEnvFile ? null # E.g. a path to ‘.bash_aliases’ file (to make aliases be available via ‘:!…’)
, with-perl-support ? true
}:
# The fzf.vim plugin needs fzf v0.24 or higher
assert ! isNull fzf -> (
  let
    versionDigits
      = builtins.map lib.toInt
      ( builtins.filter builtins.isString
      ( builtins.split "\\." fzf.version
      ));
  in
    builtins.elemAt versionDigits 0 >= 0 &&
    builtins.elemAt versionDigits 1 >= 24
);
let
  plugins = callPackage ./plugins.nix { inherit __utils __neovimRC; };

  inherit (__utils) esc wrapExecutable exe shellCheckers;

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
        ${exe coreutils "mkdir"} -- "$out"
        ${exe coreutils "cp"} -r -- ${esc rcDerivation}/{UltiSnips,my-modules,lua}/ "$out"
        ${exe coreutils "cp"} -r -- \
          ${esc rcDerivation}/{maps,options,plugins-configs,ginit}.vim "$out"

        # store original init.vim as one piece, it's linked to in $MYVIMRC
        # which is also used by config reloading hotkey.
        ${exe coreutils "cp"} -- ${esc fullInitFile} "$out"/${esc fullInitFile.name}

        echo > "$out/plugins.vim" # just a dummy plug

        # for post-pluings part of the init.vim being interpreted as a package (latest in the order)
        ${exe coreutils "mkdir"} -- "$out/plugin"
        ${exe coreutils "cp"} -- ${esc postFile} "$out/plugin/"${esc postFile.name}
      '';

  wenzelsNeovimGeneric = { forGUI ? false }:
    assert builtins.isBool forGUI;
    let
      configDir = rcDirGeneric { inherit forGUI; };

      wrap = neovim:
        let
          deps =
            (lib.optional (fzf != null) fzf) ++
            (lib.optional with-perl-support perlForNeovim);
        in
        symlinkJoin {
          name = "${lib.getName neovim}-wrapper";
          nativeBuildInputs = [ makeWrapper ];
          paths = [ neovim ];
          postBuild = ''
            nvim="$out"/bin/nvim

            wrapProgram "$out"/bin/nvim ${
              if deps != []
              then "--prefix PATH : ${esc (lib.makeBinPath deps)}"
              else ""
            }

            # Smoke test
            (
              set -o nounset

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
      wrap (neovim.override {
        configure = {
          packages.myPlugins = {
            start = plugins.own ++ plugins.other;
            opt = [];
          };

          customRC = ''
            let $MYVIMRC = '${configDir}/init.vim'
            let &rtp .= ',${configDir}' " for UltiSnips
            se pp-=~/.vim/after
            so ${initFiles.pre} " pre plugins init stage
            let &pp .= ',${configDir}' " postpone post plugins init stage
          '';
        };
      });
in
{
  inherit wenzelsNeovimGeneric; # main export
  inherit rcDirGeneric init ginit initParts initFiles; # just for debug
}
