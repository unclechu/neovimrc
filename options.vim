" custom vim options
" Author: Viacheslav Lotsmanov

let $NVIM_ENABLE_TRUE_COLOR = 1

set hidden " ctrlspace requires it
set laststatus=2 " airline always
set showtabline=2

set backspace=indent,eol,start
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set smartindent
set noexpandtab

set splitright
set splitbelow

set hlsearch
set smartcase

set nowrap
set number
set relativenumber
set nocursorline
set nocursorcolumn
set colorcolumn=81 " one column after limit
set textwidth=80
set showcmd " show combos at the right bottom corner
set inccommand=split
set virtualedit=all

set mouse=a

set fileencodings=utf8,cp1251
set modeline
set foldmethod=indent
set foldlevelstart=999
set cpoptions+=I " disable indent removing in insert mode (moving by arrow keys)
set timeoutlen=1000

" sessions
set ssop-=options " do not store global and local values in a session
set ssop-=folds   " do not store folds

set showbreak=↪
set linebreak
set breakindentopt=shift:4,sbr
set breakindent

set wildmenu

set clipboard-=unnamedplus
set termguicolors

set path+=**,**/.* " recursively deal with files
