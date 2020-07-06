{ pkgs     ? import <nixpkgs> {}
, neovimRC ? ../.
}:
let
  inherit (import ./utils.nix { inherit pkgs; }) esc lines;

  pluginsOverrides = {
    # own plugins
    vim-line-no-indicator = {
      rev = "8704d4836cef4b2a73c767db293f2487b636e1e7"; # "patch-1" branch, 9 January 2020
      sha256 = "19cd3xa9zih3kkgzmzw1kj13aiwcdq40mkjw8hwijdz25m4cbjw5";
    };
    haskell-vim = {
      rev = "28cdd5e0075e795485d9d03ed54e9d1890622808"; # "my-fork" branch, 3 July 2019
      sha256 = "19kmzjq1vs6j95gqydlmysgvkhpimhc3lihg88vl03bs1by0y9i7";
    };
    lushtags = {
      rev = "ee328f6c74bd5a128206cecb0849a194d6e03470"; # "master" branch, 23 December 2017
      sha256 = "1nn75n8cmay9b42c72kzs5c9bldl34ci1d29xb82623ymya7yjw0";
    };
    # other plugins
    ## utils/functionality
    vim-ctrlspace = {
      rev = "1a8937dff063d22e681910567528ec9a563d2717"; # "master" branch, 6 March 2020
      sha256 = "0r2n9k56f4v3iz58dpy6iansg6lak4vaifqjh800cpzbws41wpx5";
    };
    delimitmate = {
      rev = "728b57a6564c1d2bdfb9b9e0f2f8c5ba3d7e0c5c"; # "master" branch, 19 June 2017
      sha256 = "0fskm9gz81dk8arcidrm71mv72a7isng1clssqkqn5wnygbiimsn";
    };
    "ctrlsf.vim" = {
      rev = "9503f99336c9088bbc062fdf8fa57a014d2b8c48"; # "master" branch, 10 April 2020
      sha256 = "0bigzqvijdgf3d58z8psqmmdajb6zrygbwn7ggx1m0s9mlzppslk";
    };
    "vim-quickhl" = {
      rev = "9df53aacbff2709049b787109102b45163190c82"; # "master" branch, 20 December 2019
      sha256 = "0kl91nxlgdhjv32ghnzbiwkhsy5dbrv0p7m126l51xhnkmz24n0g";
    };
    "braceless.vim" = {
      rev = "3928fe18fb7c8561beed6a945622fd985a8e638b"; # "master" branch, 1 May 2017
      sha256 = "12nlcrvw78bf8i7lxr2hvdnaannkril00az68r40fgc5pqmrdb22";
    };
    "neovim-gui-shim" = {
      rev = "a2dce90891339b0fbf05700146263adbcb713207"; # "master" branch, 5 August 2019
      sha256 = "0ykx6c7bdcfpc59p6vkphnf8abd0q733rvdrmla5d0xix56scjb9";
    };
    "vim-smoothie" = {
      rev = "d3de4fbd7a9331b3eb05fa632611ebd34882cc83"; # "master" branch, 2 December 2019
      sha256 = "1bsqnz02jaydr92mmcrdlva4zxs28zgxwgznr2bwk4wnn26i54p6";
    };
    ## filetype-specific
    "vim-haskell-indent" = {
      rev = "fdac6d9466e3ce247737ee230c40f36162be4026"; # "master" branch, 31 January 2020
      sha256 = "0nb8fdpm1qmjvppsbcdjfkmsx688r73g0i79hx2d080zqxp4917p";
    };
    "vim-raku" = {
      rev = "8fd581b880be72b1b7358496abfda29948adbb09"; # "master" branch, 18 January 2020
      sha256 = "0ckh0n509sw2i35a6s662pkqwpjlbf1bpbzmyvaw3y18xnnalph0";
    };
    "vim-faust" = {
      rev = "6c329ddf32349e4f161e0c7a3570ad095fd8acc8"; # "master" branch, 6 July 2018
      sha256 = "1z5by6qn21vpq86ca24xzx5kz3q151cfqskqm4g7liwaj2hrkbc4";
    };
    "cider-nrepl" = {
      rev = "958c0c13bb9bc7c369adbe8466dbdf03f34888e9"; # "master" branch, 1 May 2020
      sha256 = "1kmzrn29235p1g2b5a4wbn818i991glxnph66nafvhlhi4cdfrvh";
    };
    "vim-racket" = {
      rev = "65e6e61e4492fefdddd992158d784cc751401590"; # "master" branch, 16 March 2020
      sha256 = "1ai5fh6m708grialss5kyy9cxi603zc880mswy9r6f6q58j78idq";
    };
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
    "vim-pug" = {
      rev = "ea39cd942cf3194230cf72bfb838901a5344d3b3"; # "master" branch, 23 September 2019
      sha256 = "07141jkfnaia4ydc6qcg0bc06w720l2lzl7bm4bsjwswqrzmhfam";
    };
    "vim-jst" = {
      rev = "eb25d585c9ff0f5152cea4c64c2db2228c7347bf"; # "master" branch, 23 March 2015
      sha256 = "1pnfrshp9sc5w59cj607pxprk40y6sjm2j3aac13x80rknhnaxcg";
    };
    "vim-ansible-yaml" = {
      rev = "a6f92d17ff01b2e63d6c9fdbb7f7e13c7fd41d14"; # "master" branch, 31 October 2017
      sha256 = "0226sx4ccb46jqbg2nnnf81sbq0rw5r84i070xngqjs34n3hr7gq";
    };
    "vim-rdf" = {
      rev = "4b3b4c9f079b65d2b525f567715f0aabe60cfdf3"; # "master" branch, 5 June 2016
      sha256 = "051piyf403k98zxjv0qm68qhgajwv57hblxdab2awsyvk9gzv5lc";
    };
    "vim-jinja2-syntax" = {
      rev = "b59d179defbc9fd6e6f426569f8430592e1a6a1b"; # "master" branch, 20 April 2020
      sha256 = "00p2h8rlhmlmm8776a4fcb1bldxz61wdg24m11cm7kgxr34xh6rr";
    };
    "nginx.vim" = {
      rev = "152bbb2dc00c2df37049ccf75f68f294208c72cb"; # "master" branch, 25 November 2010
      sha256 = "16d21sci6v4chiv9sc0g073l37yz0my2jh7hzck0y2rhixm955wm";
    };
    "pgsql.vim" = {
      rev = "e6372ca8f88d88eb532eb140128bb034d5ab0564"; # "master" branch, 30 June 2016
      sha256 = "079cs6w757jayr0qfznr8zjkbbv84h1v3ncahqq9q12vh9kybrny";
    };
    ## colorschemes
    "vim-distinguished" = {
      rev = "62b360dc81355b53d124cd06218a9ba2496563fc"; # "master" branch, 5 August 2013
      sha256 = "12qjblyb58cwqjvngfcq1alqvcy0z8rnkwvs7czjcc9x6z3dfjzn";
    };
    "jellybeans.vim" = {
      rev = "ef83bf4dc8b3eacffc97bf5c96ab2581b415c9fa"; # "master" branch, 22 June 2019
      sha256 = "1zy3gjz5bna3l5a7k2ddqa0w7x8wbndy2vc9gmqfdsxdbhrgpvaz";
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
      rev = "dae23a0210af295e5e696dcec9641dd28ad4916a"; # "master" branch, 9 June 2009
      sha256 = "1av86nydi56cljw8l5pmwfc4gc858ld0k1qjsdk646qaqdsqgg4a";
    };
    "railscasts" = {
      rev = "4e32f0421ef099ba86b66dbe65f0cf5a6a1d7e7f"; # "master" branch, 20 May 2009
      sha256 = "0m75ghsn6mqjlirv7fz7gxyyl8ymbl5j4jsipzqmhjp0yd4lad3q";
    };
    "twilight" = {
      rev = "61d8d3e49507ae69d32951d63edf9755c87f4da6"; # "master" branch, 30 April 2009
      sha256 = "19d2yyr2jll071c647p1fw504i52zgmcg1xp3sf83lf37s449sn7";
    };
    "vim-solarized8" = {
      rev = "5df7666374ead07a482605b53a0f36c27dc17e8d"; # "master" branch, 11 December 2019
      sha256 = "1nvlb00lajzbhfsbsjw6f7hi37xrnyfhf0a7cgjvf3jp2piwjs2d";
    };
    "vim" = {
      rev = "e39aba8a83b5c869e8edc04cbf3ea587472401ab"; # "master" branch, 18 December 2019
      sha256 = "145pfnzs87ypfizhmhnpy0k4lpzfx9wf87d1gdwa0c0vs8cki0a0";
    };
    "oceanic-next" = {
      rev = "08158eec24cd154afd1623686aeb336fad580be7"; # "master" branch, 10 April 2019
      sha256 = "1s2h9mnhl54ww7zpdllwlxz93d5i7l7rx3s9mr8w6sv8azcak3v8";
    };
    "onedark.vim" = {
      rev = "4bd965e29811e29e1c1b0819f3a63671d3e6ef28"; # "master" branch, 1 May 2020
      sha256 = "168zim0ifkg441iwwpxdb93fq4ap2ps0rnrad5lqycpgwr0v0bg2";
    };
    "vim-monokai" = {
      rev = "ae7753878f8740fbdb2cef5617911ef83255349b"; # "master" branch, 16 January 2019
      sha256 = "12jl1axi6pz6bv36xk4jchm9ya881kjhmzag1awnz73cmw22yll9";
    };
    "habiLight" = {
      rev = "b1db6936fa8c168fc1b24fb991b0229f18c96ec3"; # "master" branch, 25 April 2006
      sha256 = "0na4hicxs4ny25666zr8x5d73kpfwmnfb4iiwyiaadp4jk9rnjdh";
    };
    "tomorrow-theme" = {
      rev = "de38ebc802bdc611c4404b5cd8db941dd6d2c171"; # "master" branch, 8 June 2019
      sha256 = "003sjh3nn5bjgfx126x60kwk60vdxijbrpa0375bfl4v4c6g2l7l";
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

  mkGhPlugin = plugin: pkgs.vimUtils.buildVimPlugin rec {
    name = builtins.elemAt plugin 1;

    src =
      let
        origin =
          pkgs.fetchFromGitHub ({
            owner = builtins.head plugin;
            repo = name;
          } // pluginsOverrides.${name});
      in
        pkgs.runCommand "${name}-clean" {} ''
          set -Eeuo pipefail
          mkdir -- "$out"
          cp -r -- ${esc origin}/* "$out"
          rm -f -- "$out/Makefile"
        '';
  };

  plugins =
    let
      srcLines = lines (builtins.readFile "${neovimRC}/plugins.vim");

      ghReposList =
        let
          filterPlugs = builtins.filter (x: builtins.substring 0 5 x == "Plug ");
          getGhRepo = x: builtins.elemAt (builtins.split "'" x) 2;
          splitOwnerAndRepo = x: builtins.filter builtins.isString (builtins.split "/" x);
          splitOwnAndOther = builtins.partition (x: builtins.head x == "unclechu");
          ownAndOtherAttrs = x: { own = x.right; other = x.wrong; };
        in
          ownAndOtherAttrs
            (splitOwnAndOther
              (builtins.map (x: splitOwnerAndRepo (getGhRepo x)) (filterPlugs srcLines)));

      asPlugins = x: {
        own = builtins.map mkGhPlugin x.own; # own plugins are always overridden
        other =
          let
            expandPlugin = p:
              let
                name = builtins.elemAt p 1;
                hasOverride = builtins.hasAttr name pluginsOverrides;
                hasDotVim = builtins.match ".+\.vim" name != null;
                hasRename = builtins.hasAttr name pluginsRenames || hasDotVim;

                renamed =
                  if builtins.hasAttr name pluginsRenames
                  then pluginsRenames.${name}
                  else builtins.substring 0 (builtins.stringLength name - 4) name + "-vim";

                fromNixpkgs = pkgs.vimPlugins.${if hasRename then renamed else name};
              in
                if hasOverride then mkGhPlugin p else fromNixpkgs;
          in
            builtins.map expandPlugin x.other;
      };
    in
      asPlugins ghReposList;
in
plugins
