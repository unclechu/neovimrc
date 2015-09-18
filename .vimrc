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
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'drmikehenry/vim-fontsize'
Plugin 'scrooloose/nerdcommenter'
Plugin 'pangloss/vim-javascript'
Plugin 'kchmck/vim-coffee-script'
Plugin 'gkz/vim-ls'
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
Plugin 'bling/vim-airline'
Plugin 'szw/vim-ctrlspace'

"snipmate
Plugin 'tomtom/tlib_vim'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'garbas/vim-snipmate'

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
let g:CtrlSpaceIgnoredFiles = '\v(\.git|\.hg|\.svn|node_modules|bower_components|__pycache__)[\/]'
let g:indentLine_enabled = 0
let g:indent_guides_start_level = 1
let g:indent_guides_auto_colors = 0
let g:indent_guides_enable_on_vim_startup = 1
vmap <Enter> <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
let g:snipMate = {}
let g:snipMate.scope_aliases = {}

"load my modules
syntax on
runtime! my-modules/**/*.vim

"some vim configs

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

call ResetKeyMap()
call PreventIndentTrimHackOn()

let mapleader = '\'

"provide forward deleting in Insert and Command-Line modes
inoremap <C-l> <Del>
cnoremap <C-l> <Del>

" flying between buffers
" (c) https://bairuidahu.deviantart.com/art/Flying-vs-Cycling-261641977
nnoremap <leader>l :ls<CR>:b<space>
nnoremap <leader>k :ls<CR>:bd<space>

" fn-keys map

nmap <F1>  :tabnew<CR>
imap <F1>  <Esc><F1>
vmap <F1>  <Esc><F1>

nmap <F2>  :w<CR>
imap <F2>  <Esc><F2>
vmap <F2>  <Esc><F2>

"reset search by <F3>
nmap <F3>  :let @/ = ""<CR>
imap <F3>  <Esc><F3>
vmap <F3>  <Esc><F3>

nmap <F4>  <C-W><Right>:tabclose<CR>
imap <F4>  <Esc><F4>
vmap <F4>  <Esc><F4>

nmap <F5>  :NERDTreeMirrorToggle<CR>
imap <F5>  <Esc><F5>
vmap <F5>  <Esc><F5>

nmap <F6>  :TagbarToggle<CR>
imap <F6>  <Esc><F6>
vmap <F6>  <Esc><F6>

"some hack for snippets
imap <F8>  <Esc>a

nmap <F9>  :set ft=
vmap <F9>  <Esc><F9>
imap <F9>  <Esc><F9>

nmap <F10> :WrapToggle<CR>
vmap <F10> <Esc><F10>
imap <F10> <Esc><F10>a

nmap <F11> :PasteToggle<CR>
vmap <F11> <Esc><F11>
"only enable, cause can't handle keys in paste mode
imap <F11> <Esc><F11>a

nmap <F12> :
imap <F12> <Esc><F12>
vmap <F12> :

inoremap <C-V> <Esc>lv

nnoremap <C-Tab> :wincmd w<CR>
nnoremap <C-S-Tab> :wincmd W<CR>

nnoremap <C-Z> u
inoremap <C-Z> <Esc>u
vnoremap <C-Z> <Esc>u

nnoremap <C-Up>   g<Up>
nnoremap <C-Down> g<Down>
vnoremap <C-Up>   g<Up>
vnoremap <C-Down> g<Down>
inoremap <C-Up>   <Esc>g<Up>a
inoremap <C-Down> <Esc>g<Down>a

"custom digraphs
digraphs '' 769 "accent
digraphs 3. 8230 "dots

"include local vimrc
let g:vimrcpost = expand('~') . '/.vimrc-local-post'
if filereadable(g:vimrcpost)
	exec 'source ' . g:vimrcpost
endif
