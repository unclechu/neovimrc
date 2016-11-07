" NeoVim config
" Author: Viacheslav Lotsmanov
" vim: set noet fenc=utf-8 :

" required for vundle
filetype off
set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#begin("~/.config/nvim/bundle")
Plugin 'gmarik/Vundle.vim', {'pinned': 1} " provided by git-submodule

" plugins
Plugin 'scrooloose/nerdtree'
" Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'xuyuanp/nerdtree-git-plugin'
Plugin 'scrooloose/nerdcommenter'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'kchmck/vim-coffee-script'
Plugin 'gkz/vim-ls'

" typescript
" also: http://vimawesome.com/plugin/typescript-tools
Plugin 'leafgarland/typescript-vim'
" WARNING! requires to run `make` inside bundle/vimproc.vim by bare hands!
Plugin 'Shougo/vimproc.vim'
Plugin 'Quramy/tsuquyomi'

Plugin 'groenewege/vim-less'
Plugin 'wavded/vim-stylus'
Plugin 'digitaltoad/vim-jade'
Bundle 'chase/vim-ansible-yaml'
Plugin 'elzr/vim-json'
Plugin 'niklasl/vim-rdf'
Bundle 'gmoe/vim-faust'
Plugin 'plasticboy/vim-markdown'
Bundle 'zah/nimrod.vim'
Plugin 'nginx.vim'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'mattn/emmet-vim'
Plugin 'briancollins/vim-jst'
Plugin 'junegunn/vim-easy-align'
Plugin 'ap/vim-css-color'
Plugin 'henrik/vim-indexed-search'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'majutsushi/tagbar'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'unclechu/vim-ctrlspace'
Plugin 'scrooloose/syntastic'
Plugin 'SirVer/ultisnips'
Plugin 'haya14busa/incsearch.vim'
Plugin 'haya14busa/incsearch-easymotion.vim'
Plugin 'tpope/vim-commentary'
Plugin 'Shougo/unite.vim'   " unite
" Plugin 'Shougo/denite.nvim' " future async replacement for unite
Plugin 'Shougo/neomru.vim'  " unite 'file_mru'
Plugin 'Shougo/neoyank.vim' " unite clipboard history 'history/yank'
Plugin 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'} " async autocompletion
Plugin 'sjl/gundo.vim'
Plugin 'mhinz/vim-startify'
Plugin 'mileszs/ack.vim'
Plugin 'tpope/vim-fugitive'
" Plugin 'embear/vim-localvimrc'
Plugin 'itchyny/vim-haskell-indent'
Plugin 'eagletmt/neco-ghc'
Plugin 'eagletmt/ghcmod-vim'
Plugin 'bitc/lushtags'
Plugin 'easymotion/vim-easymotion'
Plugin 'matze/vim-move'
Plugin 'raimondi/delimitmate'
Plugin 'dyng/ctrlsf.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 't9md/vim-quickhl'
Plugin 'tweekmonster/braceless.vim'
Plugin 'equalsraf/neovim-gui-shim'

" surround
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'

" clojure
Plugin 'clojure-emacs/cider-nrepl'
Plugin 'tpope/vim-fireplace'
Plugin 'kien/rainbow_parentheses.vim'

" colorschemes
Plugin 'morhetz/gruvbox'

" required for vundle
call vundle#end()
filetype plugin indent on

" plugins config
let NERDTreeIgnore = ['\.swp', '\.swo', '\.pyc', '__pycache__']
let NERDTreeShowHidden = 1 " always show hidden files in NERDTree
let NERDTreeMapHelp = '<Leader>?' " heals backward search
let NERDTreeShowLineNumbers = 1
let NERDTreeWinSize = 40
let NERDTreeMapOpenVSplit = 'S' " for easymotion 's' map
let g:nerdtree_tabs_open_on_gui_startup     = 0
let g:nerdtree_tabs_open_on_console_startup = 0
let g:nerdtree_tabs_open_on_new_tab         = 0
let g:airline#extensions#tabline#enabled    = 0
let g:airline#extensions#whitespace#enabled = 0
set laststatus=2 " airline always
set hidden " ctrlspace
set showtabline=2
let g:CtrlSpaceDefaultMappingKey = "<C-Space>"
let g:CtrlSpaceUseArrowsInTerm = 1
let g:indentLine_enabled = 0
let g:indent_guides_start_level = 1
let g:indent_guides_auto_colors = 0
let g:indent_guides_enable_on_vim_startup = 0
vmap <Enter> <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
let g:snipMate = {}
let g:snipMate.scope_aliases = {}
let g:syntastic_enable_signs = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 2
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_loc_list_height = 5
let g:syntastic_enable_highlighting = 0
let g:tsuquyomi_disable_quickfix = 1
let g:syntastic_typescript_checkers = ['tsuquyomi', 'tslint']
let g:syntastic_python_checkers = ['python']
let g:syntastic_python_python_exec = '/usr/bin/python3'
let g:indent_guides_exclude_filetypes =
	\ ['help', 'nerdtree', 'tagbar', 'clojure', 'haskell', 'cabal', 'startify']
let g:user_emmet_leader_key = '<C-Z>'
let g:indexed_search_mappings = 0
let g:EasyMotion_do_mapping = 0 " disable default mappings
let g:EasyMotion_smartcase = 1 " turn on case insensitive feature
let g:gitgutter_map_keys = 0
let g:deoplete#enable_at_startup = 1

let g:unite_source_menu_menus = get(g:, 'unite_source_menu_menus', {})
let g:unite_source_menu_menus.ls = { 'description': 'LiveScript/LS' }
let g:unite_source_menu_menus.ls.command_candidates = [
	\ ['Compile selected chunk to JS using LSC', "'<,'>!lsc -cbps | sed 1d"],
	\ ['Get AST from selected chunk using LSC', "'<,'>!lsc -cbpsa"]
	\]
let g:unite_source_menu_menus.unite = { 'description': 'Unite call presets' }
let g:unite_source_menu_menus.unite.command_candidates = [
	\ ['MRU', 'Unite -auto-resize file_mru'],
	\ ['Buffers', 'Unite -auto-resize buffer'],
	\ [
	\  'MRU + Buffers (insert)',
	\  'Unite -auto-resize -start-insert file_mru buffer'
	\ ],
	\ ['Grep by Git files', 'Unite -auto-resize grep/git:.'],
	\ ['Grep by Git files (case insensitive)', 'Unite -auto-resize grep/git:.:-i'],
	\ ['Grep by Git files (bare string)', 'Unite -auto-resize grep/git:.:-F'],
	\ [
	\  'Grep by Git files (bare string and case insensitive)',
	\  'Unite -auto-resize grep/git:.:-iF'
	\ ]
	\]

" merge all menu items to single group
let s:u_all = []
let s:u_max_prefix_length = 0
for [k, v] in items(g:unite_source_menu_menus)
	if s:u_max_prefix_length < len(v.description)
		let s:u_max_prefix_length = len(v.description)
	endif
	for item in v.command_candidates
		call add(s:u_all, [v.description, item[0], item[1]])
	endfor
endfor
let s:u_all_pfx = []
for item in s:u_all
	let s:u_desc = item[0]
	while len(s:u_desc) < s:u_max_prefix_length
		let s:u_desc = s:u_desc . ' '
	endwhile
	call add(s:u_all_pfx, [s:u_desc . ' | ' . item[1], item[2]])
endfor
let g:unite_source_menu_menus.all = { 'description': 'All actions' }
let g:unite_source_menu_menus.all.command_candidates = s:u_all_pfx
unlet s:u_all
unlet s:u_all_pfx
unlet s:u_max_prefix_length
unlet s:u_desc

call unite#custom#source(
	\ 'file_rec,file_rec/async,file_rec/neovim',
	\ 'ignore_pattern',
	\ '\v\.git/|\.hg/|\.svn/|__pycache__/|node_modules/|bower_components/'
	\   . '\.exe$|\.so$|\.dll$|\.swp$|\.swo$'
	\)

" load my modules
syntax on
runtime! my-modules/**/*.vim

" some vim configs

let $NVIM_ENABLE_TRUE_COLOR = 1

set backspace=indent,eol,start
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set smartindent
set noexpandtab

set hlsearch
set smartcase

set nowrap
set number
set relativenumber
set nocursorline
set nocursorcolumn
set colorcolumn=80
set showcmd " show combos at the right bottom corner

set mouse=a

set fileencodings=utf8,cp1251
set modeline
set foldmethod=indent
set foldlevelstart=999
set cpoptions+=I " disable indent removing in insert mode (moving by arrow keys)

" sessions
set ssop-=options " do not store global and local values in a session
set ssop-=folds   " do not store folds

set showbreak=˪
set linebreak
" try-catch for old vim versions
try
	set breakindentopt=shift:4,sbr
	set breakindent
catch
endtry

set wildmenu

set clipboard-=unnamedplus
set termguicolors

call PreventIndentTrimHackOn()

let mapleader = ','

" flying between buffers
" (c) https://bairuidahu.deviantart.com/art/Flying-vs-Cycling-261641977
nnoremap <leader>bl :ls<CR>:b<space>
nnoremap <leader>bd :ls<CR>:bd<space>

nnoremap <leader>r :let @/ = ''<CR>:echo 'Reset search'<CR>

" nnoremap <leader>n :NERDTreeMirrorToggle<CR>
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>fn :NERDTreeFind<CR>
nnoremap <leader>t :TagbarToggle<CR>
nnoremap <leader>u :GundoToggle<CR>

" Unite
nnoremap <A-p>      :tabnew<CR>:Unite -auto-resize -start-insert file_rec/neovim buffer<CR>
nnoremap <C-p>      :Unite -auto-resize -start-insert file_rec/neovim buffer<CR>
nnoremap <leader>y  :Unite -auto-resize history/yank -default-action=append<CR>
nnoremap ''         :Unite -auto-resize register<CR>
" sl - show lines
nnoremap <leader>sl :Unite -auto-resize -start-insert line<CR>
" sa - show all
nnoremap <leader>sa :Unite -auto-resize -start-insert line:buffers<CR>
nnoremap <leader>;  :Unite -auto-resize -start-insert menu:all<CR>
vnoremap <leader>;  :Unite -auto-resize -start-insert menu:all<CR>
nnoremap <leader>:  :Unite -auto-resize<Space>
" feels kinda like ctrlspace
nnoremap <leader><Space> :Unite -auto-resize buffer<CR>
nnoremap <Space><leader> :Unite -auto-resize file_mru<CR>

" GitGutter keys
nnoremap <leader>gv :GitGutterPreviewHunk<CR>
nnoremap <Leader>ga :GitGutterStageHunk<CR>
nnoremap <Leader>gr :GitGutterUndoHunk<CR>
nmap ]c <Plug>GitGutterNextHunk
nmap [c <Plug>GitGutterPrevHunk

" git status in new tab
nnoremap <leader>gs :tabnew %<CR>:Gstatus<CR><C-w>o
nnoremap <leader>gS :Gstatus<CR><C-w>o

" modes togglers
nnoremap <leader>mw :WrapToggle<CR>
nnoremap <leader>mp :PasteToggle<CR>
nnoremap <leader>ml :ListToggle<CR>
nnoremap <leader>mn :RelativeNumberToggle<CR>
nnoremap <leader>m] :DelimitMateSwitch<CR>
nnoremap <leader>mg :GitGutterToggle<CR>
nnoremap <leader>mc :AutoClearSpacesAtEOFToggle<CR>

" some buffer configs
nnoremap <leader>ft :set filetype=
nnoremap <leader>fl :set foldlevel=
nnoremap <leader>fm :set foldmethod=

" some windows things
nnoremap <leader>sww :set winwidth=
nnoremap <leader>swh :set winheight=

" Syntastic
nnoremap <leader>si :SyntasticInfo<CR>
nnoremap <leader>sc :SyntasticCheck<CR>
nnoremap <leader>sr :SyntasticReset<CR>

" show hint
nnoremap <leader>sh :ShowHint<CR>

" short EasyAlign aliases
vnoremap <leader>: :EasyAlign/:/<CR>
nnoremap <leader>a :EasyAlign
vnoremap <leader>a :EasyAlign

" CtrlSF bindings
nmap     <leader>sf <Plug>CtrlSFPrompt
vmap     <leader>sf <Plug>CtrlSFVwordPath
vmap     <leader>sF <Plug>CtrlSFVwordExec
nmap     <leader>sn <Plug>CtrlSFCwordPath
nmap     <leader>sN <Plug>CtrlSFCwordExec
nmap     <leader>sp <Plug>CtrlSFPwordPath
nmap     <leader>sP <Plug>CtrlSFPwordExec
nnoremap <leader>so :CtrlSFOpen<CR>
nnoremap <leader>st :CtrlSFToggle<CR>


" EasyMotion bindings (<Space> for overwin-mode, <Leader> for current window)

nmap s         <Plug>(easymotion-bd-w)
vmap s         <Plug>(easymotion-bd-w)
nmap <Space>s  <Plug>(easymotion-overwin-w)
vmap <Space>s  <Nop>
nmap <leader>s <Nop>
vmap <leader>s <Nop>

nmap <leader>x <Plug>(easymotion-bd-jk)
vmap <leader>x <Plug>(easymotion-bd-jk)
nmap <Space>x  <Plug>(easymotion-overwin-line)
vmap <Space>x  <Nop>

nmap <leader>w <Plug>(easymotion-bd-f2)
vmap <leader>w <Plug>(easymotion-bd-f2)
nmap <Space>w  <Plug>(easymotion-overwin-f2)
vmap <Space>w  <Nop>

nmap <leader>v v<Plug>(easymotion-bd-w)
nmap <leader>V V<Plug>(easymotion-bd-jk)

nmap <leader>l <Plug>(easymotion-lineforward)
vmap <leader>l <Plug>(easymotion-lineforward)
nmap <leader>h <Plug>(easymotion-linebackward)
vmap <leader>h <Plug>(easymotion-linebackward)
nmap <leader>j <Plug>(easymotion-j)
vmap <leader>j <Plug>(easymotion-j)
nmap <leader>k <Plug>(easymotion-k)
vmap <leader>k <Plug>(easymotion-k)


" quickhl
nmap <Space>m <Plug>(quickhl-manual-this)
xmap <Space>m <Plug>(quickhl-manual-this)
nmap <Space>M <Plug>(quickhl-manual-reset)
xmap <Space>M <Plug>(quickhl-manual-reset)
nmap <Space>n <Plug>(quickhl-cword-toggle)


" remove word selection symbols after paste from search
nmap <leader>c/ ds\ds>
" paste searched word and clean it
map <leader>p/  '/phds\ds>
map <leader>P/  '/Phds\ds>

" system buffer alias without shift modifier (like <Space> is specific buffer)
noremap '<Space> "+

" forward version of <C-h> in insert mode
inoremap <C-l> <Del>


" colorscheme stuff
noremap <leader>ss <Esc>:set background=
noremap <leader>sb :BackgroundToggle<CR>
noremap <leader>sc :GruvboxContrastRotate<CR>


" hjkl
nnoremap <C-h>     :wincmd h<CR>
vnoremap <C-h>     <Esc>:wincmd h<CR>
nnoremap <C-j>     :wincmd j<CR>
vnoremap <C-j>     <Esc>:wincmd j<CR>
nnoremap <C-k>     :wincmd k<CR>
vnoremap <C-k>     <Esc>:wincmd k<CR>
nnoremap <C-l>     :wincmd l<CR>
vnoremap <C-l>     <Esc>:wincmd l<CR>
" arrow keys
nnoremap <C-Left>  :wincmd h<CR>
vnoremap <C-Left>  <Esc>:wincmd h<CR>
nnoremap <C-Right> :wincmd l<CR>
vnoremap <C-Right> <Esc>:wincmd l<CR>
nnoremap <C-Up>    :wincmd k<CR>
vnoremap <C-Up>    <Esc>:wincmd k<CR>
nnoremap <C-Down>  :wincmd j<CR>
vnoremap <C-Down>  <Esc>:wincmd j<CR>

" walk between windows by alt+arrow keys
nnoremap <A-Left>  zh
vnoremap <A-Left>  zh
nnoremap <A-Right> zl
vnoremap <A-Right> zl
nnoremap <A-Up>    <C-y>
vnoremap <A-Up>    <C-y>
nnoremap <A-Down>  <C-e>
vnoremap <A-Down>  <C-e>

" resizing windows by alt+shift+arrow keys
nnoremap <A-S-Left>  :wincmd <<CR>
vnoremap <A-S-Left>  <Esc>:wincmd <<CR>
nnoremap <A-S-Right> :wincmd ><CR>
vnoremap <A-S-Right> <Esc>:wincmd ><CR>
nnoremap <A-S-Up>    :wincmd +<CR>
vnoremap <A-S-Up>    <Esc>:wincmd +<CR>
nnoremap <A-S-Down>  :wincmd -<CR>
vnoremap <A-S-Down>  <Esc>:wincmd -<CR>

" zoom buffer hack
nnoremap <leader>zz :999wincmd ><CR>:999wincmd +<CR>
vnoremap <leader>zz <Esc>:999wincmd ><CR>:999wincmd +<CR>gv

" moving between history in command mode
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" moving tabs
nnoremap <C-S-PageUp>   :tabm-1<CR>
nnoremap <C-S-PageDown> :tabm+1<CR>

" jump by half of screen by pageup/pagedown
nmap <PageUp>     <C-u>
nmap <PageDown>   <C-d>
vmap <PageUp>     <C-u>
vmap <PageDown>   <C-d>
" default jump by pageup/pagedown with shift prefix
nmap <S-PageUp>   <C-b>
nmap <S-PageDown> <C-f>
vmap <S-PageUp>   <C-b>
vmap <S-PageDown> <C-f>

nmap g/        <Plug>(incsearch-easymotion-/)
nmap g?        <Plug>(incsearch-easymotion-?)
nmap <leader>/ <Plug>(incsearch-easymotion-stay)

if &mouse == 'a'
	nmap <C-ScrollWheelUp>   <leader><leader>+
	nmap <C-ScrollWheelDown> <leader><leader>-
endif

" get rid off randomly turning ex-mode on
map Q  <Nop>
map gQ <Nop>

" get rid off randomly turning macros-writing on
map q  <Nop>
noremap gq q

" thanks to Minoru for the advice
noremap ; :
noremap : ;

" thanks to r3lgar for the advice (swap default <leader> and comma)
noremap \ ;
noremap \| ,

" because working with clipboard registers is more important
noremap ' "
noremap " '
noremap "" ''

" custom behavior of big R in visual mode
vnoremap R r<Space>R

" custom numbers line keys
nmap ! <Plug>(indexed-search-#)
nnoremap g! yiw:let @/ = '\V\<<C-R>0\>'<CR>:ShowSearchIndex<CR>
nmap @ <Plug>(indexed-search-*)
nnoremap g@ yiw:let @/ = '\V\<<C-R>0\>'<CR>:ShowSearchIndex<CR>
" noremap ! #
" noremap @ *
noremap # ^
noremap g# g^
noremap $ g_
noremap g$ g$
" noremap %
noremap ^ 0
noremap g^ g0
noremap & $
noremap g& g$
noremap * @
noremap g* g@

" because default maps disabled for plugin
nmap / <Plug>(indexed-search-/)
nmap ? <Plug>(indexed-search-?)
nmap n <Plug>(indexed-search-n)zv
nmap N <Plug>(indexed-search-N)zv

xnoremap ! :<C-u>call VisualStarSearchSet('?')<CR>?<C-R>=@/<CR><CR>
xnoremap @ :<C-u>call VisualStarSearchSet('/')<CR>/<C-R>=@/<CR><CR>

" custom digraphs
digraphs '' 769 " accent
digraphs 3. 8230 " dots

let g:gruvbox_contrast_dark = 'medium'
let g:gruvbox_contrast_light = 'soft'
colorscheme gruvbox
set background=dark

set shell=/bin/bash
let $BASH_ENV = "~/.bash_aliases"

" :terminal colorscheme
let g:terminal_color_0  = '#073642'
let g:terminal_color_1  = '#dc322f'
let g:terminal_color_2  = '#859900'
let g:terminal_color_3  = '#b58900'
let g:terminal_color_4  = '#268bd2'
let g:terminal_color_5  = '#d33682'
let g:terminal_color_6  = '#2aa198'
let g:terminal_color_7  = '#eee8d5'
let g:terminal_color_8  = '#002b36'
let g:terminal_color_9  = '#cb4b16'
let g:terminal_color_10 = '#586e75'
let g:terminal_color_11 = '#657b83'
let g:terminal_color_12 = '#839496'
let g:terminal_color_13 = '#6c71c4'
let g:terminal_color_14 = '#93a1a1'
let g:terminal_color_15 = '#fdf6e3'

command! MakeTags !ctags -R .
set path+=** " recursively deal with files

" include local rc
let g:neovimrc = expand('~') . '/.neovimrc-local-post'
if filereadable(g:neovimrc)
	exec 'source ' . g:neovimrc
endif
