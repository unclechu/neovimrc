" plugins loading
" Author: Viacheslav Lotsmanov

if $DEIN_DIR == '' | let $DEIN_DIR = $HOME . '/.config/nvim/dein' | endif

if $DEIN_BASE_PATH == ''
	let $DEIN_BASE_PATH = $HOME . '/.cache/nvim-dein-plugins'
endif

set rtp+=$DEIN_DIR

if dein#load_state($DEIN_BASE_PATH)
	call dein#begin($DEIN_BASE_PATH)
	call dein#add($DEIN_DIR, {'frozen': 1})
	call dein#add('wsdjeg/dein-ui.vim')

	" utils/functionality
	call dein#add('scrooloose/nerdtree')
	" dein#add('jistr/vim-nerdtree-tabs')
	call dein#add('scrooloose/nerdcommenter')
	call dein#add('editorconfig/editorconfig-vim')
	call dein#add('junegunn/vim-easy-align')
	call dein#add('godlygeek/tabular')
	call dein#add('henrik/vim-indexed-search')
	call dein#add('terryma/vim-multiple-cursors')
	call dein#add('nathanaelkane/vim-indent-guides')
	call dein#add('majutsushi/tagbar')
	call dein#add('vim-airline/vim-airline')
	call dein#add('vim-airline/vim-airline-themes')
	call dein#add('vim-ctrlspace/vim-ctrlspace')
	call dein#add('SirVer/ultisnips')
	call dein#add('haya14busa/incsearch.vim')
	call dein#add('haya14busa/incsearch-easymotion.vim')
	call dein#add('tpope/vim-commentary')
	call dein#add('tpope/vim-speeddating')
	" call dein#add('Shougo/unite.vim')   " was before denite.nvim
	call dein#add('Shougo/denite.nvim') " new replacement for unite
	call dein#add('Shougo/neomru.vim')  " unite/denite 'file_mru'
	" TODO FIXME denite
	" call dein#add('Shougo/neoyank.vim') " unite clipboard history 'history/yank'
	call dein#add('chemzqm/denite-git')
	call dein#add('Shougo/deoplete.nvim') " async autocompletion
	" call dein#add('autozimu/LanguageClient-neovim', {
	" 	\ 'rev': 'next',
	" 	\ 'build': 'bash install.sh',
	" 	\ })
	call dein#add('w0rp/ale') " replacement for 'autozimu/LanguageClient-neovim'
	call dein#add('junegunn/fzf')
	call dein#add('sjl/gundo.vim')
	call dein#add('mhinz/vim-startify')
	call dein#add('mileszs/ack.vim')
	" dein#add('embear/vim-localvimrc')
	call dein#add('easymotion/vim-easymotion')
	" call dein#add('matze/vim-move')
	call dein#add('raimondi/delimitmate')
	call dein#add('dyng/ctrlsf.vim')
	call dein#add('t9md/vim-quickhl')
	call dein#add('tweekmonster/braceless.vim')
	call dein#add('equalsraf/neovim-gui-shim')
	" dein#add('blueyed/vim-diminactive') " works bad with NERDTree for example
	call dein#add('ryanoasis/vim-devicons')
	call dein#add('tpope/vim-dadbod')
	call dein#add('yuttie/comfortable-motion.vim')
	call dein#add('wsdjeg/FlyGrep.vim')
	call dein#add('junegunn/goyo.vim')
	call dein#add('junegunn/limelight.vim')

	" surround
	call dein#add('tpope/vim-surround')
	call dein#add('tpope/vim-repeat')
	call dein#add('wellle/targets.vim')

	" linting
	" dein#add('scrooloose/syntastic')
	call dein#add('neomake/neomake')
	call dein#add('sbdchd/neoformat')

	" git
	call dein#add('xuyuanp/nerdtree-git-plugin')
	call dein#add('tpope/vim-fugitive')
	call dein#add('airblade/vim-gitgutter')

	" haskell
	" call dein#add('unclechu/vim-my-haskell') " my old fork for syntax
	" call dein#add('neovimhaskell/haskell-vim')
	call dein#add('unclechu/haskell-vim') " my fork with unicode support
	call dein#add('unclechu/lushtags')
	call dein#add('twinside/vim-hoogle')
	call dein#add('itchyny/vim-haskell-indent')

	" purescript
	call dein#add('raichoo/purescript-vim')

	" perl
	call dein#add('vim-perl/vim-perl6')

	" faust
	call dein#add('gmoe/vim-faust')

	" nim
	call dein#add('zah/nim.vim')
	" call dein#add('unclechu/nvim-nim')

	" kotlin
	call dein#add('udalov/kotlin-vim')

	" lisp
	"   clojure
	call dein#add('clojure-emacs/cider-nrepl')
	call dein#add('tpope/vim-fireplace')
	call dein#add('kien/rainbow_parentheses.vim')
	"   racket
	call dein#add('wlangstroth/vim-racket')

	" asscript
	call dein#add('pangloss/vim-javascript')
	call dein#add('mxw/vim-jsx')
	call dein#add('flowtype/vim-flow')

	" coffee/live-script
	call dein#add('kchmck/vim-coffee-script')
	call dein#add('gkz/vim-ls')

	" typescript
	" also: http://vimawesome.com/plugin/typescript-tools
	call dein#add('leafgarland/typescript-vim')
	call dein#add('Shougo/vimproc.vim', {'build': 'make'})
	call dein#add('Quramy/tsuquyomi')

	" styles
	call dein#add('groenewege/vim-less')
	call dein#add('wavded/vim-stylus')
	call dein#add('ap/vim-css-color')

	" markup/data
	call dein#add('plasticboy/vim-markdown')
	call dein#add('digitaltoad/vim-pug')
	call dein#add('briancollins/vim-jst')
	call dein#add('chase/vim-ansible-yaml')
	call dein#add('elzr/vim-json')
	call dein#add('niklasl/vim-rdf')
	call dein#add('mattn/emmet-vim')

	" configs
	call dein#add('vim-scripts/nginx.vim')

	" sql
	call dein#add('exu/pgsql.vim')

	" colorschemes
	call dein#add('morhetz/gruvbox') " gruvbox
	call dein#add('tomasr/molokai') " molokai
	call dein#add('Lokaltog/vim-distinguished') " distinguished
	call dein#add('nanotech/jellybeans.vim') " jellybeans
	call dein#add('rakr/vim-one') " one (supports 'bg' option)
	call dein#add('trevordmiller/nova-vim') " nova
	call dein#add('liuchengxu/space-vim-theme') " space_vim_theme
	call dein#add('antlypls/vim-colors-codeschool') " codeschool
	call dein#add('vim-scripts/TuttiColori-Colorscheme') " tutticolori
	call dein#add('vim-scripts/railscasts')
	call dein#add('vim-scripts/twilight')
	" solarized8 solarized8_flat solarized8_high solarized8_low
	call dein#add('lifepillar/vim-solarized8')
	call dein#add('fenetikm/falcon')
	call dein#add('challenger-deep-theme/vim') " challenger_deep
	call dein#add('mhinz/vim-janah') " janah
	call dein#add('mhartington/oceanic-next') " OceanicNext OceanicNextLight
	" let g:airline_theme = 'onedark'
	call dein#add('joshdick/onedark.vim') " onedark
	call dein#add('sickill/vim-monokai') " monokai (not very good for haskell)
	call dein#add('junegunn/seoul256.vim') " seoul256 seoul256-light
	" light theme, just for fun, last update in 2006
	call dein#add('vim-scripts/habiLight')

	" utils
	call dein#add('sl4m/left-pad.vim')

	call dein#end()
	call dein#save_state()
endif

" from dein's readme
filetype plugin indent on
syntax enable
