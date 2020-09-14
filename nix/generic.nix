{ pkgs        ? import ./default-nixpkgs-pick.nix
, bashEnvFile ? null
, neovimRC    ? ../.
}:
let
  utils   = import ./utils.nix   { inherit pkgs;          };
  plugins = import ./plugins.nix { inherit pkgs neovimRC; };

  inherit (utils) esc lines unlines;

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
        mkdir -- "$out"
        cp -r -- ${esc rcDerivation}/{UltiSnips,my-modules}/ "$out"
        cp -r -- ${esc rcDerivation}/{maps,options,plugins-configs,ginit}.vim "$out"

        # store original init.vim as one piece, it's linked to in $MYVIMRC
        # which is also used by config reloading hotkey.
        cp -- ${esc fullInitFile} "$out"/${esc fullInitFile.name}

        echo > "$out/plugins.vim" # just a dummy plug

        # for post-pluings part of the init.vim being interpreted as a package (latest in the order)
        mkdir -- "$out/plugin"
        cp -- ${esc postFile} "$out/plugin/"${esc postFile.name}
      '';

  wenzelsNeovimGeneric = { forGUI ? false }:
    assert builtins.isBool forGUI;
    let
      configDir = rcDirGeneric { inherit forGUI; };
    in
      pkgs.neovim.override {
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
      };
in
{
  inherit wenzelsNeovimGeneric; # main export
  inherit rcDirGeneric init ginit initLines initFiles; # just for debug
}
