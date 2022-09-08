# Author: Viacheslav Lotsmanov
# License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE

# This module is intended to be called with ‘nixpkgs.callPackage’
{ callPackage
, fetchFromGitHub
, runCommand
, lib
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

  # GitHub plugins overrides
  ghPluginsOverrides = {
    # own plugins
    vim-line-no-indicator = {
      rev = "8704d4836cef4b2a73c767db293f2487b636e1e7"; # "patch-1" branch, 9 January 2020
      sha256 = "19cd3xa9zih3kkgzmzw1kj13aiwcdq40mkjw8hwijdz25m4cbjw5";
    };
    haskell-vim = {
      rev = "f74fb1955b7a4f11349c2973a04bcdd4c8b36d73"; # "my-fork" branch, 29 October 2020
      sha256 = "1naa7h08jrdciy9aib6kyla6scp3qjy90n081s6yas6hmn356fkz";
    };
    lushtags = {
      rev = "ee328f6c74bd5a128206cecb0849a194d6e03470"; # "master" branch, 23 December 2017
      sha256 = "1nn75n8cmay9b42c72kzs5c9bldl34ci1d29xb82623ymya7yjw0";
    };
    # other plugins
    ## utils/functionality
    vim-ctrlspace = {
      rev = "357b337a3494aae8f9c2075a5c120467833d753d"; # "master" branch, 26 April 2021
      sha256 = "1yjx79yj21dbf746mmw6y3mf9j20yar7vww1isyhi3a3pb4l7wsl";
    };
    "ctrlsf.vim" = {
      rev = "51c5b285146f042bd2015278f9b8ad74ae915e00"; # "master" branch, 21 May 2021
      sha256 = "1901cr6sbaa8js4ylirz9p4m0r9q0a06gm71ghl6kp6pw7h5fgmq";
    };
    "vim-quickhl" = {
      rev = "b63d478a7860dded6a6b675a0bdd891c022f1027"; # "master" branch, 13 November 2020
      sha256 = "19v8yynyk5zwp2vxgddffld302kqp0vcasx6y9lk80y3b13vjl43";
    };
    "braceless.vim" = {
      rev = "3928fe18fb7c8561beed6a945622fd985a8e638b"; # "master" branch, 1 May 2017
      sha256 = "12nlcrvw78bf8i7lxr2hvdnaannkril00az68r40fgc5pqmrdb22";
    };
    "neovim-gui-shim" = {
      rev = "668188542345e682addfc816af38b7073d376a64"; # "master" branch, 27 March 2021
      sha256 = "1s1ws7cfhg0rjfzf5clr2w6k9b8fkd57jzfna3vx1caymwspwrw2";
    };
    "vim-lsp-ale" = {
      rev = "4ca0425dc6f74d7e1be18a4e2205c8e3bc190d24"; # “master” branch, 3 November 2021
      sha256 = "0jv0fhyd7d3iil69gmbdignsswry46hjzh4syjbd4ij8wyprzjdw";
    };
    "asyncomplete-lsp.vim" = {
      rev = "684c34453db9dcbed5dbf4769aaa6521530a23e0"; # “master” branch, 27 June 2020
      sha256 = "0vqx0d6iks7c0liplh3x8vgvffpljfs1j3g2yap7as6wyvq621rq";
    };
    "dirbuf.nvim" = {
      rev = "24a2d4d2fbff4f11f68f332471bec7a138b527f2"; # “master” branch, 24 January 2022
      sha256 = "1jszxvmfphy29sk7yqkphjdcbi6zk7dqz0gfa3fgv463krcpia4l";
    };
    ## filetype-specific
    "vim-haskell-indent" = {
      rev = "f4da5bc71ae7de9525c8c23fe44664f3e8ad79cd"; # "master" branch, 15 August 2020
      sha256 = "0x5infc2r0py28iqijx874sblbh6k9a777x6i2hy4gb6a5ixx0rq";
    };
    "vim-raku" = {
      rev = "d2944a9b6644558a7b58c4886471918faf530d5b"; # "master" branch, 11 May 2020
      sha256 = "06nkw1dzg9s4w5zva5as8y62hlpz5f5r7c47yp3vza7lzb4c8f62";
    };
    "vim-faust" = {
      rev = "6c329ddf32349e4f161e0c7a3570ad095fd8acc8"; # "master" branch, 4 July 2018
      sha256 = "1z5by6qn21vpq86ca24xzx5kz3q151cfqskqm4g7liwaj2hrkbc4";
    };
    "cider-nrepl" = {
      rev = "3d80096127b6481a18abadb8e45091c3390dc40d"; # "master" branch, 31 July 2020
      sha256 = "0p0hngm3armhmcvkzb3q5nnw12dvz2adf6iw23hamyr6mhyl627b";
    };
    # TODO Try https://github.com/peitalin/vim-jsx-typescript/ (pkgs.vimPlugins.vim-jsx-typescript)
    "vim-jsx" = {
      rev = "8879e0d9c5ba0e04ecbede1c89f63b7a0efa24af"; # "master" branch, 29 September 2019
      sha256 = "0czjily7kjw7bwmkxd8lqn5ncrazqjsfhsy3sf2wl9ni0r45cgcd";
    };
    "vim-flow" = {
      rev = "8d9499da1c9e7b77feb9cf04bd289e48859a6024"; # "master" branch, 13 August 2019
      sha256 = "0qhsiccmjx9pgqz6l917klkgwf7abz94cli7w1spwhfm1i51irjy";
    };
    "vim-ls" = {
      rev = "795568338ecdc5d8059db2eb84c7f0de3388bae3"; # "master" branch, 29 March 2015
      sha256 = "0p3dbwfsqhhzh7icsiaa7j09zp5r8j7xrcaw6gjxcxqlhv86jaa1";
    };
    "vim-less" = {
      rev = "6e818d5614d5fc18d95a48c92b89e6db39f9e3d6"; # "master" branch, 25 April 2016
      sha256 = "0rhqcdry8ycnfbg534q4b3hm78an7mnqhiazxik7k08a57dk9dbm";
    };
    "vim-stylus" = {
      rev = "0514757a4795843978517ee73d7fa7d8bf2e5545"; # "master" branch, 15 October 2015
      sha256 = "1n3qs5lsf4q2x9vs4ch4dx8zp43n14cwlywdvh857mcmnf8xjlz8";
    };
    "vim-jst" = {
      rev = "eb25d585c9ff0f5152cea4c64c2db2228c7347bf"; # "master" branch, 23 March 2015
      sha256 = "1pnfrshp9sc5w59cj607pxprk40y6sjm2j3aac13x80rknhnaxcg";
    };
    # TODO Try https://github.com/pearofducks/ansible-vim/ (pkgs.vimPlugins.ansible-vim)
    "vim-ansible-yaml" = {
      rev = "a6f92d17ff01b2e63d6c9fdbb7f7e13c7fd41d14"; # "master" branch, 31 October 2017
      sha256 = "0226sx4ccb46jqbg2nnnf81sbq0rw5r84i070xngqjs34n3hr7gq";
    };
    "vim-rdf" = {
      rev = "4b3b4c9f079b65d2b525f567715f0aabe60cfdf3"; # "master" branch, 5 June 2016
      sha256 = "051piyf403k98zxjv0qm68qhgajwv57hblxdab2awsyvk9gzv5lc";
    };
    # TODO Try https://github.com/lepture/vim-jinja/ (pkgs.vimPlugins.vim-jinja)
    "vim-jinja2-syntax" = {
      rev = "ceb0f8076ee9aa802668448cefdd782edff4f6b2"; # "master" branch, 23 May 2020
      sha256 = "0vb07nhw2l165804lcfw831n20c7aa3hbsvidhz9magp0csfgphc";
    };
    # TODO Try https://github.com/chr4/nginx.vim/ (pkgs.vimPlugins.nginx-vim)
    "nginx.vim" = {
      rev = "152bbb2dc00c2df37049ccf75f68f294208c72cb"; # "master" branch, 27 November 2010
      sha256 = "16d21sci6v4chiv9sc0g073l37yz0my2jh7hzck0y2rhixm955wm";
    };
    "pgsql.vim" = {
      rev = "e6372ca8f88d88eb532eb140128bb034d5ab0564"; # "master" branch, 30 June 2016
      sha256 = "079cs6w757jayr0qfznr8zjkbbv84h1v3ncahqq9q12vh9kybrny";
    };
    "vim-venter" = {
      rev = "8cbb93f912a85e320a3eaeee0b9ee5934043930a"; # “master” branch, 21 November 2021
      sha256 = "sha256-mwOaGrgyvTCC3TnoATq65YqcQRipVOkYAlbobT1oVIo=";
    };
    ## colorschemes
    "vim-distinguished" = {
      rev = "62b360dc81355b53d124cd06218a9ba2496563fc"; # "master" branch, 5 August 2013
      sha256 = "12qjblyb58cwqjvngfcq1alqvcy0z8rnkwvs7czjcc9x6z3dfjzn";
    };
    "nova-vim" = {
      rev = "e587d14c655a4d2d048556eaaa5419a14f17826a"; # "master" branch, 27 August 2019
      sha256 = "0qdr84iykm8jrfl5q4clqv335blp3lj57isg0ylz1wak1gkn9dx8";
    };
    "space-vim-theme" = {
      rev = "4790dbba31f678f75af4f4c7a1465008542bd979"; # "master" branch, 18 September 2019
      sha256 = "1nv099x5qq8mal9dwjj29dk357mzhn4vb9wljhglra9imammrz43";
    };
    "vim-colors-codeschool" = {
      rev = "27e95bc21caf06edec42ec60547871c72ca42232"; # "master" branch, 12 March 2015
      sha256 = "1ix1x513rsi2gr9qir1hb2njn0y841dw9p05yjkwkid1f3n8wrw7";
    };
    "TuttiColori-Colorscheme" = {
      rev = "dae23a0210af295e5e696dcec9641dd28ad4916a"; # "master" branch, 18 October 2010
      sha256 = "1av86nydi56cljw8l5pmwfc4gc858ld0k1qjsdk646qaqdsqgg4a";
    };
    "railscasts" = {
      rev = "4e32f0421ef099ba86b66dbe65f0cf5a6a1d7e7f"; # "master" branch, 18 October 2010
      sha256 = "0m75ghsn6mqjlirv7fz7gxyyl8ymbl5j4jsipzqmhjp0yd4lad3q";
    };
    "twilight" = {
      rev = "61d8d3e49507ae69d32951d63edf9755c87f4da6"; # "master" branch, 18 October 2010
      sha256 = "19d2yyr2jll071c647p1fw504i52zgmcg1xp3sf83lf37s449sn7";
    };
    "vim-solarized8" = {
      rev = "5df7666374ead07a482605b53a0f36c27dc17e8d"; # "master" branch, 11 December 2019
      sha256 = "1nvlb00lajzbhfsbsjw6f7hi37xrnyfhf0a7cgjvf3jp2piwjs2d";
    };
    # challenger_deep
    "vim" = {
      rev = "e39aba8a83b5c869e8edc04cbf3ea587472401ab"; # "master" branch, 18 December 2019
      sha256 = "145pfnzs87ypfizhmhnpy0k4lpzfx9wf87d1gdwa0c0vs8cki0a0";
    };
    "habiLight" = {
      rev = "b1db6936fa8c168fc1b24fb991b0229f18c96ec3"; # "master" branch, 18 October 2010
      sha256 = "0na4hicxs4ny25666zr8x5d73kpfwmnfb4iiwyiaadp4jk9rnjdh";
    };
    "tomorrow-theme" = {
      rev = "de38ebc802bdc611c4404b5cd8db941dd6d2c171"; # "master" branch, 8 June 2019
      sha256 = "003sjh3nn5bjgfx126x60kwk60vdxijbrpa0375bfl4v4c6g2l7l";
    };
    "toast.vim" = {
      rev = "2da3ee3e0ad80187401ce95caf0285128f53d3b0"; # "master" branch, 27 October 2020
      sha256 = "0s3wsd6c1dhjbdnl9vzdxz3078smhb130q3c3r2zm0zaply3ixxl";
    };
    ## utils
    "left-pad.vim" = {
      rev = "9f5e1e68e7934b7c61042b12f24275e614bcde9f"; # "master" branch, 25 March 2016
      sha256 = "00kra5nzxq8spjp161pfl13ysj825qa9mfyk1m41vya98qz5c4vh";
    };
  };

  pluginsRenames = {
    "fzf" = "fzfWrapper";
  };

  # Highest priority, will override in any case.
  # Allows to use a plugin from a local directory or from anywhere else.
  # Use with “mkPlugin” function.
  rawPluginsOverrides = {
    # haskell-vim = mkPlugin "haskell-vim" (lib.cleanSource ../../haskell-vim);
  };

  mkGhPlugin = plugin:
    let
      name = builtins.elemAt plugin 1;

      src = fetchFromGitHub ({
        owner = builtins.head plugin;
        repo = name;
      } // ghPluginsOverrides.${name});
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
