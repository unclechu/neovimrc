# Author: Viacheslav Lotsmanov
# License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE

# This module is intended to be called with ‘nixpkgs.callPackage’
{ callPackage
, fetchFromGitHub
, runCommand
, lib
, nix-gitignore
, coreutils
, vimUtils
, vimPlugins

# Overridable dependencies
, __utils ? callPackage ./utils.nix {}

# Build options
, __neovimRC ? __utils.cleanSource ../.
}:
let
  inherit (__utils) esc exe;

  # GitHub plugins overrides.
  #
  # You can update pins of all these plugins like this:
  #   niv -s nix/plugins/sources.json update
  # N.B. Mind that there are quite many of them. GitHub might start responding with “rate limit
  # exceeded”. You can avoid this by providing a GITHUB_TOKEN you can create on this page
  # https://github.com/settings/tokens (you need a GitHub accout for this) and then run:
  #   GITHUB_TOKEN=your-token niv -s nix/plugins/sources.json update
  #
  # TODO Try https://github.com/pearofducks/ansible-vim/ (pkgs.vimPlugins.ansible-vim) instead of vim-ansible-yaml
  # TODO Try https://github.com/lepture/vim-jinja/ (pkgs.vimPlugins.vim-jinja) instead of vim-jinja2-syntax
  # TODO Try https://github.com/chr4/nginx.vim/ (pkgs.vimPlugins.nginx-vim) instead of nginx.vim
  ghPluginsOverrides = import ./sources.nix { sourcesFile = plugins/sources.json; };

  pluginsRenames = {
    "fzf" = "fzfWrapper";

    # Without this “rename” I get this error:
    #   error: attribute 'sc-vim' missing
    "scnvim" = "scnvim";
  };

  # Highest priority, will override in any case.
  # Allows to use a plugin from a local directory or from anywhere else.
  # Use with “mkPlugin” function.
  rawPluginsOverrides = {
    # "bullets.vim" =
    #   mkPlugin
    #   "bullets.vim"
    #   (nix-gitignore.gitignoreRecursiveSource [ ../bullets.vim/.gitignore ] ../bullets.vim);

    nvim-treesitter = callPackage plugins/treesitter.nix {};
  };

  mkGhPlugin = plugin:
    let
      name = builtins.elemAt plugin 1;
      override = ghPluginsOverrides.${name};

      src =
        if ! builtins.hasAttr "outPath" override
        then fetchFromGitHub ({ owner = builtins.head plugin; repo = name; } // override)
        else override;
    in
      mkPlugin name src;

  mkPlugin = name: origin: vimUtils.buildVimPlugin {
    inherit name;
    pname = name; # This is mandatory for newer nixpkgs

    src = runCommand "${name}-clean" {} ''
      set -Eeuo pipefail || exit
      ${exe coreutils "mkdir"} -- "$out"
      ${exe coreutils "cp"} -r -- ${esc origin}/* "$out"
      ${exe coreutils "rm"} -f -- "$out/Makefile"
    '';
  };

  # { own   :: [Derivation]
  # , other :: [Derivation]
  # }
  #
  # Where Derivation is a Vim plugin defined using “vimUtils.buildVimPlugin” function.
  #
  plugins =
    let
      # A list of GitHub repositories.
      #
      # { own   :: [(String, String)]
      # , other :: [(String, String)]
      # }
      #
      # Where first String in the tuple is repository owner and second is repository name.
      #
      ghReposList =
        lib.pipe "${__neovimRC}/plugins.vim" [
          builtins.readFile
          (lib.splitString "\n")
          (builtins.filter (x: builtins.substring 0 5 x == "Plug "))

          (builtins.map (lib.flip lib.pipe [
            (lib.flip lib.pipe [ (lib.splitString "'") (lib.flip builtins.elemAt 1) ])
            (lib.splitString "/")
          ]))

          (builtins.partition (x: builtins.head x == "unclechu"))
          (x: { own = x.right; other = x.wrong; })
        ];

      asPlugins = x: {
        # Own plugins are always overridden.
        # If there is “raw” override for an “own” plugin then it has more priority.
        own =
          let
            toPlugin = p:
              let name = builtins.elemAt p 1;
              in rawPluginsOverrides.${name} or (mkGhPlugin p);
          in
            builtins.map toPlugin x.own;

        other =
          let
            expandPlugin = p:
              let
                name = builtins.elemAt p 1;
                hasRawOverride = builtins.hasAttr name rawPluginsOverrides;
                hasOverride = builtins.hasAttr name ghPluginsOverrides;
                hasDotVim = builtins.match ".+\.vim" name != null;
                hasRename = builtins.hasAttr name pluginsRenames || hasDotVim;

                renamed =
                  if builtins.hasAttr name pluginsRenames
                  then pluginsRenames.${name}
                  else builtins.substring 0 (builtins.stringLength name - 4) name + "-vim";

                fromNixpkgs = vimPlugins.${if hasRename then renamed else name};
              in
                if hasRawOverride then rawPluginsOverrides.${name}
                else if hasOverride then mkGhPlugin p
                else fromNixpkgs;
          in
            builtins.map expandPlugin x.other;
      };
    in
      asPlugins ghReposList;
in
plugins
