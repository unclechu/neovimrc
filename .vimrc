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
Bundle 'gmoe/vim-faust'
Plugin 'plasticboy/vim-markdown'
Bundle 'zah/nimrod.vim'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'mattn/emmet-vim'
Plugin 'briancollins/vim-jst'
Plugin 'junegunn/vim-easy-align'
Plugin 'bling/vim-airline'
Plugin 'ap/vim-css-color'
Plugin 'henrik/vim-indexed-search'
Plugin 'kristijanhusak/vim-multiple-cursors'
Plugin 'nathanaelkane/vim-indent-guides'

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
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#whitespace#enabled = 0
let g:ctrlp_custom_ignore = {
	\ 'dir':  '\v[\/](\.git|\.hg|\.svn|node_modules|bower_components|__pycache__)$',
	\ 'file': '\v\.(exe|so|dll)$',
	\ 'link': '',
	\ }
let g:indentLine_enabled = 0
let g:indent_guides_start_level = 1
let g:indent_guides_auto_colors = 0
let g:indent_guides_enable_on_vim_startup = 1
vmap <Enter> <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

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

"dirty hacks for ignore trim trailing whitespace
inoremap <CR> x<Backspace><CR>x<Backspace>
inoremap <C-j> x<Backspace><C-j>x<Backspace>
nnoremap o ox<Backspace>
nnoremap O Ox<Backspace>

set showbreak=˪
set linebreak
"try-catch for old vim versions
try
	set breakindentopt=shift:4,sbr
	set breakindent
catch
endtry

let mapleader = ','

"provide forward deleting in Insert and Command-Line modes
inoremap <C-l> <Del>
cnoremap <C-l> <Del>

"hotkeys
nmap <F1>  :tabnew<CR>
"reset search (removes hilighting)
nmap <F3>  :let @/ = ""<CR>
"tabs
nmap <F4>  <C-W><Right>:tabclose<CR>
nmap <F5>  :NERDTreeMirrorToggle<CR>
nmap <F10> :DeleteHiddenBuffers<CR>

"custom digraphs
digraphs '' 769 "accent
digraphs 3. 8230 "dots

"include local vimrc
let g:vimrcpost = expand('~') . '/.vimrc-local-post'
if filereadable(g:vimrcpost)
	exec 'source ' . g:vimrcpost
endif
