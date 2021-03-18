let
  sources = import ./sources.nix;
  default-fzf = import ./default-fzf.nix;
in
# This module is intended to be called with ‘nixpkgs.callPackage’
{ callPackage
, runCommand
, writeText
, config
, lib
, coreutils
, neovim

# Overridable dependencies
, __utils ? callPackage ./utils.nix {}
, __fzf   ? default-fzf config # Set to “null” if you want to use global version

# Build options
, __neovimRC  ? __utils.cleanSource ../.
, bashEnvFile ? null # E.g. a path to ‘.bash_aliases’ file (to make aliases be available via ‘:!…’)
}:
# The fzf.vim plugin needs fzf v0.24 or higher which currently is provided only in nixpkgs-unstable.
assert ! isNull __fzf -> (
  let
    versionDigits
      = builtins.map lib.toInt
      ( builtins.filter builtins.isString
      ( builtins.split "\\." __fzf.version
      ));
  in
    builtins.elemAt versionDigits 0 >= 0 &&
    builtins.elemAt versionDigits 1 >= 24
);
let
  plugins = callPackage ./plugins.nix { inherit __utils __neovimRC; };

  inherit (__utils) esc lines unlines wrapExecutable exe shellCheckers;

  rcDerivation = "${__neovimRC}";

  rcDirName = "wenzels-neovim";
  rcDirNameForGUI = "${rcDirName}-for-gui";

  init  = builtins.readFile "${rcDerivation}/init.vim";
  ginit = builtins.readFile "${rcDerivation}/ginit.vim";

  initLines =
    let
      isPluginsImport = x: builtins.match ".*so.*'/plugins.vim'" x != null;
      initial = { sep = false; pre = []; post = []; };

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
      builtins.foldl' reducer initial (lines init);

  initFiles = {
    pre  = writeText "pre-plugins-init.vim"  (unlines initLines.pre);
    post = writeText "post-plugins-init.vim" (unlines initLines.post);

    postForGui = writeText "post-plugins-init-for-gui.vim" ''
      ${unlines initLines.post}
      ${ginit}
    '';
  };

  rcDirGeneric = { forGUI ? false }:
    assert builtins.isBool forGUI;
    let
      fullInitFile = writeText "init.vim" ''
        ${unlines initLines.pre}
        ${unlines initLines.post}
        ${if forGUI then ginit else ""}
      '';

      postFile = if forGUI then initFiles.postForGui else initFiles.post;
    in
      runCommand (if forGUI then rcDirNameForGUI else rcDirName) {} ''
        set -Eeuo pipefail || exit
        ${exe coreutils "mkdir"} -- "$out"
        ${exe coreutils "cp"} -r -- ${esc rcDerivation}/{UltiSnips,my-modules}/ "$out"
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

      wrap = neovim: if isNull __fzf then neovim else
        let
          nvim-exe = "${neovim}/bin/nvim";
        in
          wrapExecutable nvim-exe {
            deps = [
              neovim # To have other executables (e.g. “nvim-python”)
              __fzf
            ];
            checkPhase = shellCheckers.fileIsExecutable nvim-exe;
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
  inherit rcDirGeneric init ginit initLines initFiles; # just for debug
}
