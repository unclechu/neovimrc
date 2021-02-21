let
  sources = import ./sources.nix;
  default-fzf = (import sources.nixpkgs-for-fzf {}).fzf;
in
{ pkgs        ? import sources.nixpkgs {}
, utils       ? import ./utils.nix { inherit pkgs; }
, fzf         ? default-fzf # Set to “null” if you want to use global version
, bashEnvFile ? null
, neovimRC    ? utils.gitignore ../.
}:
# The fzf.vim plugin needs fzf v0.24 or higher which currently is provided only in nixpkgs-unstable.
assert ! isNull fzf -> (
  let
    versionDigits
      = builtins.map pkgs.lib.toInt
      ( builtins.filter builtins.isString
      ( builtins.split "\\." fzf.version
      ));
  in
    builtins.elemAt versionDigits 0 >= 0 &&
    builtins.elemAt versionDigits 1 >= 24
);
let
  plugins = import ./plugins.nix { inherit pkgs utils neovimRC; };

  inherit (utils) esc lines unlines wrapExecutable exe;

  rcDerivation = "${neovimRC}";

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
    pre  = pkgs.writeText "pre-plugins-init.vim"  (unlines initLines.pre);
    post = pkgs.writeText "post-plugins-init.vim" (unlines initLines.post);

    postForGui = pkgs.writeText "post-plugins-init-for-gui.vim" ''
      ${unlines initLines.post}
      ${ginit}
    '';
  };

  rcDirGeneric = { forGUI ? false }:
    assert builtins.isBool forGUI;
    let
      fullInitFile = pkgs.writeText "init.vim" ''
        ${unlines initLines.pre}
        ${unlines initLines.post}
        ${if forGUI then ginit else ""}
      '';

      postFile = if forGUI then initFiles.postForGui else initFiles.post;
    in
      pkgs.runCommand (if forGUI then rcDirNameForGUI else rcDirName) {} ''
        set -Eeuo pipefail
        ${exe pkgs.coreutils "mkdir"} -- "$out"
        ${exe pkgs.coreutils "cp"} -r -- ${esc rcDerivation}/{UltiSnips,my-modules}/ "$out"
        ${exe pkgs.coreutils "cp"} -r -- \
          ${esc rcDerivation}/{maps,options,plugins-configs,ginit}.vim "$out"

        # store original init.vim as one piece, it's linked to in $MYVIMRC
        # which is also used by config reloading hotkey.
        ${exe pkgs.coreutils "cp"} -- ${esc fullInitFile} "$out"/${esc fullInitFile.name}

        echo > "$out/plugins.vim" # just a dummy plug

        # for post-pluings part of the init.vim being interpreted as a package (latest in the order)
        ${exe pkgs.coreutils "mkdir"} -- "$out/plugin"
        ${exe pkgs.coreutils "cp"} -- ${esc postFile} "$out/plugin/"${esc postFile.name}
      '';

  wenzelsNeovimGeneric = { forGUI ? false }:
    assert builtins.isBool forGUI;
    let
      configDir = rcDirGeneric { inherit forGUI; };

      wrap = neovim: if isNull fzf then neovim else
        let
          nvim-exe = "${neovim}/bin/nvim";
        in
          wrapExecutable nvim-exe {
            deps = [
              neovim # To have other executables (e.g. “nvim-python”)
              fzf
            ];
            checkPhase = utils.shellCheckers.fileIsExecutable nvim-exe;
          };
    in
      wrap (pkgs.neovim.override {
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
