".vimrc
"Author: Viacheslav Lotsmanov
"vim: set noet fenc=utf-8 :

"required for vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim', {'pinned': 1} "provided by git-submodule

"plugins
Plugin 'scrooloose/nerdtree'
" Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'xuyuanp/nerdtree-git-plugin'
Plugin 'drmikehenry/vim-fontsize'
Plugin 'scrooloose/nerdcommenter'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'kchmck/vim-coffee-script'
Plugin 'gkz/vim-ls'
"also: http://vimawesome.com/plugin/typescript-tools
Plugin 'leafgarland/typescript-vim'
Plugin 'groenewege/vim-less'
Plugin 'wavded/vim-stylus'
Plugin 'digitaltoad/vim-jade'
Bundle 'chase/vim-ansible-yaml'
Plugin 'elzr/vim-json'
Plugin 'niklasl/vim-rdf'
Bundle 'gmoe/vim-faust'
Plugin 'plasticboy/vim-markdown'
Bundle 'zah/nimrod.vim'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'mattn/emmet-vim'
Plugin 'briancollins/vim-jst'
Plugin 'junegunn/vim-easy-align'
Plugin 'ap/vim-css-color'
Plugin 'henrik/vim-indexed-search'
Plugin 'kristijanhusak/vim-multiple-cursors'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'majutsushi/tagbar'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'szw/vim-ctrlspace'
Plugin 'scrooloose/syntastic'
if v:version >= 704
	Plugin 'SirVer/ultisnips'
endif
Plugin 'haya14busa/incsearch.vim'
Plugin 'tpope/vim-commentary'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'sjl/gundo.vim'
Plugin 'mhinz/vim-startify'
Plugin 'mileszs/ack.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'embear/vim-localvimrc'
Plugin 'ihacklog/hicursorwords'
Plugin 'itchyny/vim-haskell-indent'

"surround
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'

"clojure
Plugin 'clojure-emacs/cider-nrepl'
Plugin 'tpope/vim-fireplace'
Plugin 'kien/rainbow_parentheses.vim'

"colorschemes
Plugin 'altercation/vim-colors-solarized'
Plugin 'darkburn'

"required for vundle
call vundle#end()
filetype plugin indent on

"plugins config
let NERDTreeIgnore = ['\.swp', '\.swo', '\.pyc', '__pycache__']
let NERDTreeShowHidden = 1 "always show hidden files in NERDTree
let NERDTreeMapHelp = '<Leader>?' "heals backward search
let NERDTreeShowLineNumbers = 1
let NERDTreeWinSize = 50
let g:nerdtree_tabs_open_on_gui_startup     = 0
let g:nerdtree_tabs_open_on_console_startup = 0
let g:nerdtree_tabs_open_on_new_tab         = 0
let g:airline#extensions#tabline#enabled    = 0
let g:airline#extensions#whitespace#enabled = 0
set laststatus=2 "airline always
set hidden "ctrlspace
set showtabline=2
if has('gui_running')
	set guioptions-=e
endif
let g:ctrlp_custom_ignore = '\v(\.exe|\.so|\.dll|\.swp|\.git|\.hg|\.svn|\/node_modules|\/bower_components|\/__pycache__)$'
let g:ctrlp_show_hidden = 1
let g:indentLine_enabled = 0
let g:indent_guides_start_level = 1
let g:indent_guides_auto_colors = 0
let g:indent_guides_enable_on_vim_startup = 1
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
let g:syntastic_typescript_tsc_fname = '' "fix using tsconfig.json
let g:indent_guides_exclude_filetypes = [
	\ 'help', 'nerdtree', 'tagbar', 'clojure', 'haskell', 'cabal', 'startify']
let g:user_emmet_leader_key = '<C-Z>'
let g:HiCursorWords_delay = 500
let g:indexed_search_mappings = 0

"load my modules
syntax on
runtime! my-modules/**/*.vim

"some vim configs

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
if v:version >= 703
	set colorcolumn=80
endif

if has('mouse')
	set mouse=a
endif

set fileencodings=utf8,cp1251
set modeline
set foldmethod=indent
set foldlevelstart=999
set cpoptions+=I "disable indent removing in insert mode (moving by arrow keys)

"sessions
set ssop-=options " do not store global and local values in a session
set ssop-=folds   " do not store folds

set showbreak=˪
set linebreak
"try-catch for old vim versions
try
	set breakindentopt=shift:4,sbr
	set breakindent
catch
endtry

set wildmenu

call ResetKeyMap()
call PreventIndentTrimHackOn()

let mapleader = '\'

" flying between buffers
" (c) https://bairuidahu.deviantart.com/art/Flying-vs-Cycling-261641977
nnoremap <leader>l :ls<CR>:b<space>
nnoremap <leader>k :ls<CR>:bd<space>

nnoremap <leader>r :let @/ = ''<CR>:echo 'Reset search'<CR>

" nnoremap <leader>n :NERDTreeMirrorToggle<CR>
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>fn :NERDTreeFind<CR>
nnoremap <leader>t :TagbarToggle<CR>
nnoremap <leader>w :WrapToggle<CR>
nnoremap <leader>p :PasteToggle<CR>
nnoremap <leader>[ :RelativeNumberToggle<CR>
nnoremap <leader>] :AutoSurroundInputToggle<CR>
nnoremap <leader>g :GundoToggle<CR>

nnoremap <leader>ft :set filetype=
nnoremap <leader>fl :set foldlevel=
nnoremap <leader>fm :set foldmethod=

" syntastic
nnoremap <leader>si :SyntasticInfo<CR>
nnoremap <leader>sc :SyntasticCheck<CR>
nnoremap <leader>sr :SyntasticReset<CR>
nnoremap <leader>sq :lclose<CR>

nnoremap <leader>sl :ListToggle<CR>
nnoremap <leader>ss :SetSolarized<Space>

nnoremap <leader>ac :AutoClearSpacesAtEOFToggle<CR>

vnoremap <leader>: :EasyAlign/:/<CR>

"hjkl
nnoremap <C-h>     :wincmd h<CR>
vnoremap <C-h>     <Esc>:wincmd h<CR>
nnoremap <C-j>     :wincmd j<CR>
vnoremap <C-j>     <Esc>:wincmd j<CR>
nnoremap <C-k>     :wincmd k<CR>
vnoremap <C-k>     <Esc>:wincmd k<CR>
nnoremap <C-l>     :wincmd l<CR>
vnoremap <C-l>     <Esc>:wincmd l<CR>
"arrow keys
nnoremap <C-Left>  :wincmd h<CR>
vnoremap <C-Left>  <Esc>:wincmd h<CR>
nnoremap <C-Right> :wincmd l<CR>
vnoremap <C-Right> <Esc>:wincmd l<CR>
nnoremap <C-Up>    :wincmd k<CR>
vnoremap <C-Up>    <Esc>:wincmd k<CR>
nnoremap <C-Down>  :wincmd j<CR>
vnoremap <C-Down>  <Esc>:wincmd j<CR>

"walk between windows by alt+arrow keys
nnoremap <A-Left>  zh
vnoremap <A-Left>  zh
nnoremap <A-Right> zl
vnoremap <A-Right> zl
nnoremap <A-Up>    <C-y>
vnoremap <A-Up>    <C-y>
nnoremap <A-Down>  <C-e>
vnoremap <A-Down>  <C-e>

"resizing windows by alt+shift+arrow keys
nnoremap <A-S-Left>  :wincmd <<CR>
vnoremap <A-S-Left>  <Esc>:wincmd <<CR>
nnoremap <A-S-Right> :wincmd ><CR>
vnoremap <A-S-Right> <Esc>:wincmd ><CR>
nnoremap <A-S-Up>    :wincmd +<CR>
vnoremap <A-S-Up>    <Esc>:wincmd +<CR>
nnoremap <A-S-Down>  :wincmd -<CR>
vnoremap <A-S-Down>  <Esc>:wincmd -<CR>

"moving between history in command mode
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

"moving tabs
nnoremap <C-S-PageUp>   :tabm-1<CR>
nnoremap <C-S-PageDown> :tabm+1<CR>

"jump by half of screen by pageup/pagedown
nmap <PageUp>     <C-u>
nmap <PageDown>   <C-d>
vmap <PageUp>     <C-u>
vmap <PageDown>   <C-d>
imap <PageUp>     <Esc><C-u>i
imap <PageDown>   <Esc><C-d>i
"default jump by pageup/pagedown with shift prefix
nmap <S-PageUp>   <C-b>
nmap <S-PageDown> <C-f>
vmap <S-PageUp>   <C-b>
vmap <S-PageDown> <C-f>
imap <S-PageUp>   <Esc><C-b>i
imap <S-PageDown> <Esc><C-f>i

nmap g/ <Plug>(incsearch-forward)
nmap g? <Plug>(incsearch-backward)
nmap <leader>/ <Plug>(incsearch-stay)

if &mouse == 'a'
	nmap <C-ScrollWheelUp>   <leader><leader>+
	nmap <C-ScrollWheelDown> <leader><leader>-
endif

"get rid off randomly turning on ex-mode
map Q  <Nop>
map gQ <Nop>

"thanks to Minoru for the advice
noremap ; :
noremap : ;

"custom numbers line keys
nmap ! <Plug>(indexed-search-#)
nmap g! <Plug>(indexed-search-#)
nmap @ <Plug>(indexed-search-*)
nmap g@ <Plug>(indexed-search-*)
" noremap ! #
" noremap @ *
noremap # ^
noremap g# g^
noremap $ g_
noremap g$ g$
"noremap %
noremap ^ 0
noremap g^ g0
noremap & $
noremap g& g$
noremap * @
noremap g* g@
"because default maps disabled for plugin
nmap / <Plug>(indexed-search-/)
nmap ? <Plug>(indexed-search-?)
nmap n <Plug>(indexed-search-n)zv
nmap N <Plug>(indexed-search-N)zv

"custom digraphs
digraphs '' 769 "accent
digraphs 3. 8230 "dots

"include local vimrc
let g:vimrcpost = expand('~') . '/.vimrc-local-post'
if filereadable(g:vimrcpost)
	exec 'source ' . g:vimrcpost
endif
