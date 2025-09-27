" plugins loading
" Author: Viacheslav Lotsmanov
" License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE

if $PLUGINS_DIR == '' | let $PLUGINS_DIR = $HOME.'/.cache/neovim-plugins' | en
se rtp+=$PLUGINS_DIR/tomorrow-theme/vim
cal plug#begin($PLUGINS_DIR)

" utils/functionality
Plug 'scrooloose/nerdtree'
" Plug 'jistr/vim-nerdtree-tabs'
Plug 'scrooloose/nerdcommenter'
Plug 'elihunter173/dirbuf.nvim'
Plug 'junegunn/vim-easy-align'
Plug 'godlygeek/tabular'
Plug 'henrik/vim-indexed-search'
Plug 'terryma/vim-multiple-cursors' " todo: deprecated, try https://github.com/mg979/vim-visual-multi
Plug 'nathanaelkane/vim-indent-guides'
Plug 'majutsushi/tagbar'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-ctrlspace/vim-ctrlspace'
Plug 'SirVer/ultisnips'
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-easymotion.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-speeddating'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'ptzz/lf.vim'
Plug 'rbgrouleff/bclose.vim' " neovim dependency for “lf.vim”
Plug 'sjl/gundo.vim'
Plug 'mhinz/vim-startify'
Plug 'mileszs/ack.vim'
Plug 'easymotion/vim-easymotion'
Plug 'raimondi/delimitMate'
Plug 'dyng/ctrlsf.vim'
Plug 't9md/vim-quickhl'
Plug 'tweekmonster/braceless.vim'
Plug 'equalsraf/neovim-gui-shim'
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-dadbod'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
" Plug 'jceb/vim-orgmode'
Plug 'jonathanbranam/vim-orgmode' " less dead fork
Plug 'mattn/calendar-vim'
Plug 'unclechu/vim-line-no-indicator', {'branch': 'patch-1'}
Plug 'JMcKiern/vim-venter'
Plug 'dkarter/bullets.vim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'neovim/nvim-lspconfig'

" smooth scrolling
" Plug 'yuttie/comfortable-motion.vim'
Plug 'psliwka/vim-smoothie'

" surround
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'wellle/targets.vim'

" linting & lsp
Plug 'neomake/neomake'
Plug 'sbdchd/neoformat'
Plug 'dense-analysis/ale'
Plug 'prabirshrestha/vim-lsp'
Plug 'rhysd/vim-lsp-ale' " glue for ALE + vim-lsp (ALE’s readme refers to it)
Plug 'prabirshrestha/asyncomplete.vim' " primarily for using with LSP
Plug 'prabirshrestha/asyncomplete-lsp.vim'

" git
Plug 'xuyuanp/nerdtree-git-plugin'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" haskell
Plug 'wenzel-hoffman/haskell-with-unicode.vim'
Plug 'unclechu/lushtags'
Plug 'twinside/vim-hoogle'
Plug 'itchyny/vim-haskell-indent'

" purescript
Plug 'raichoo/purescript-vim'

" elm
Plug 'elmcast/elm-vim'

" nix
Plug 'LnL7/vim-nix'

" dhall
Plug 'vmchale/dhall-vim'

" perl
Plug 'Raku/vim-raku'

" faust
Plug 'gmoe/vim-faust'

" supercollider
Plug 'davidgranstrom/scnvim' " neovim frontend for supercollider

" nim
Plug 'zah/nim.vim'

" kotlin
Plug 'udalov/kotlin-vim'

" lisp
"   clojure
Plug 'clojure-emacs/cider-nrepl'
Plug 'tpope/vim-fireplace'
Plug 'kien/rainbow_parentheses.vim'
"   racket
Plug 'wlangstroth/vim-racket'

" asscript
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'flowtype/vim-flow'

" coffee/live-script
Plug 'kchmck/vim-coffee-script'
Plug 'gkz/vim-ls'

" typescript
" also: http://vimawesome.com/plugin/typescript-tools
" Plug 'leafgarland/typescript-vim'
Plug 'HerringtonDarkholme/yats.vim' " instead of 'leafgarland/typescript-vim'
" Plug 'Quramy/tsuquyomi'

" shaders
Plug 'tikhomirov/vim-glsl'

" styles
Plug 'groenewege/vim-less'
Plug 'wavded/vim-stylus'
Plug 'ap/vim-css-color'

" markup/data
Plug 'plasticboy/vim-markdown'
Plug 'digitaltoad/vim-pug'
Plug 'briancollins/vim-jst'
Plug 'chase/vim-ansible-yaml'
Plug 'elzr/vim-json'
Plug 'niklasl/vim-rdf'
Plug 'mattn/emmet-vim'
Plug 'glench/vim-jinja2-syntax'

" configs
Plug 'vim-scripts/nginx.vim'

" sql
Plug 'exu/pgsql.vim'

" csv
Plug 'chrisbra/csv.vim'

" robot framework
Plug 'mjkarki/vim-robot-syntax'
" An older archived plugin
" Plug 'mfukar/robotframework-vim'

" terraform
Plug 'hashivim/vim-terraform'

" colorschemes
Plug 'morhetz/gruvbox' " gruvbox
Plug 'tomasr/molokai' " molokai
Plug 'Lokaltog/vim-distinguished' " distinguished
Plug 'nanotech/jellybeans.vim' " jellybeans
Plug 'rakr/vim-one' " one (supports 'bg' option)
Plug 'liuchengxu/space-vim-theme' " space_vim_theme
Plug 'antlypls/vim-colors-codeschool' " codeschool
Plug 'vim-scripts/TuttiColori-Colorscheme' " tutticolori
Plug 'vim-scripts/railscasts'
Plug 'vim-scripts/twilight'
" solarized8 solarized8_flat solarized8_high solarized8_low
Plug 'lifepillar/vim-solarized8'
Plug 'fenetikm/falcon'
Plug 'challenger-deep-theme/vim' " challenger_deep
Plug 'mhinz/vim-janah' " janah
Plug 'mhartington/oceanic-next' " OceanicNext OceanicNextLight
" let g:airline_theme = 'onedark'
" Plug 'joshdick/onedark.vim' " onedark, replaced by 'olimorris/onedarkpro.nvim'
Plug 'sickill/vim-monokai' " monokai (not very good for haskell)
Plug 'junegunn/seoul256.vim' " seoul256 seoul256-light
" light theme, just for fun, last update in 2006
Plug 'vim-scripts/habiLight'
" it's not actually just a vim plugin (see patching &rtp above).
" Tomorrow-Night-Blue Tomorrow-Night-Bright Tomorrow-Night-Eighties
" Tomorrow-Night Tomorrow
Plug 'chriskempson/tomorrow-theme'
Plug 'jsit/toast.vim'

" more colorschemes found on this page:
" https://dotfyle.com/neovim/colorscheme/trending
Plug 'AlexvZyl/nordic.nvim'
Plug 'neanias/everforest-nvim'
Plug 'bluz71/vim-moonfly-colors'
Plug 'sainnhe/sonokai'
Plug 'sainnhe/gruvbox-material'
Plug 'sainnhe/everforest'
Plug 'sainnhe/edge'
Plug 'savq/melange-nvim'
Plug 'tiagovla/tokyodark.nvim'
Plug 'shaunsingh/nord.nvim'
Plug 'nyoom-engineering/oxocarbon.nvim'
Plug 'marko-cerovac/material.nvim'
Plug 'Mofiqul/dracula.nvim'
" Plug 'olimorris/onedarkpro.nvim' " preferring 'navarasu/onedark.nvim' instead
Plug 'navarasu/onedark.nvim'
Plug 'Mofiqul/vscode.nvim'
Plug 'projekt0n/github-nvim-theme'
Plug 'EdenEast/nightfox.nvim'
Plug 'ribru17/bamboo.nvim'
" FIXME: Fix this nix build error:
"        Require check failed for the following modules:
"         - solarized-osaka.extra.fzf
" Plug 'craftzdog/solarized-osaka.nvim'
Plug 'scottmckendry/cyberdream.nvim'
Plug 'rebelot/kanagawa.nvim'
Plug 'rose-pine/neovim'
Plug 'folke/tokyonight.nvim'
Plug 'catppuccin/nvim'

" utils
Plug 'sl4m/left-pad.vim'

cal plug#end()
