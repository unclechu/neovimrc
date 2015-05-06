".vimrc
"Author: Viacheslav Lotsmanov

set nocompatible
filetype off "important for vundle

set rtp+=~/.vim/bundle/vundle/

call vundle#rc()

filetype plugin indent on "important for vundle

"vundle plugins
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'kien/ctrlp.vim'
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
Plugin 'klen/python-mode'
Bundle 'gmoe/vim-faust'
Plugin 'plasticboy/vim-markdown'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'mattn/emmet-vim'
Plugin 'briancollins/vim-jst'

"vundle colorschemes
Plugin 'altercation/vim-colors-solarized'
Plugin 'darkburn'

"plugins stuff
let NERDTreeIgnore = ['\.swp', '\.swo', '\.pyc', '__pycache__']
let NERDTreeShowHidden = 1 "always show hidden files in NERDTree

"load my modules
syntax on
runtime! my-modules/**/*.vim

"modules stuff
"highlight tabs by default
call ToggleTabsHL(1)

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

set showtabline=2 "show tabs always
set fileencodings=utf8,cp1251
set modeline
set foldmethod=indent
set foldlevelstart=3
set cpoptions+=I "disable indent removing in insert mode

let mapleader = ','

"hotkeys
imap <F1> <Esc>:NewTabWithNERDTree<CR>
nmap <F1> <Esc>:NewTabWithNERDTree<CR>
imap <F2> <Esc>:ToggleAutoIndent<CR>li
nmap <F2> <Esc>:ToggleAutoIndent<CR>
"reset search (removes hilighting)
map <F3> :let @/ = ""<CR>
"provide forward deleting in Insert and Command-Line modes
inoremap <C-l> <Del>
cnoremap <C-l> <Del>
"tabs
nmap <F4> <Esc><C-W><Right>:tabclose<CR>
map <F5> :NERDTreeMirrorToggle<CR>
map <F6> :BufExplorerRelative<CR>
nmap <F7> <Esc>:tabprevious<CR>
nmap <F8> <Esc>:tabnext<CR>
nmap <F9> <Esc>:ToggleTabsHL<CR>
nmap <F10> <Esc>:DeleteHiddenBuffers<CR>

"custom digraphs
digraphs '' 769 "accent
digraphs 3. 8230 "dots

"vim: set noet :
