" NeoVim config
" Author: Viacheslav Lotsmanov
" vim: set noet fenc=utf-8 :

" required for vundle
filetype off
set rtp+=$HOME/.config/nvim/bundle/Vundle.vim
call vundle#begin($HOME . '/.config/nvim/bundle')
Plugin 'VundleVim/Vundle.vim', {'pinned': 1} " provided by git-submodule


" plugins

" utils/functionality
Plugin 'scrooloose/nerdtree'
" Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'scrooloose/nerdcommenter'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'junegunn/vim-easy-align'
Plugin 'henrik/vim-indexed-search'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'majutsushi/tagbar'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'unclechu/vim-ctrlspace'
" Plugin 'SirVer/ultisnips'
Plugin 'unclechu/my-ultisnips'
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
" Plugin 'embear/vim-localvimrc'
Plugin 'easymotion/vim-easymotion'
Plugin 'matze/vim-move'
Plugin 'raimondi/delimitmate'
Plugin 'dyng/ctrlsf.vim'
Plugin 't9md/vim-quickhl'
Plugin 'tweekmonster/braceless.vim'
Plugin 'equalsraf/neovim-gui-shim'
" Plugin 'blueyed/vim-diminactive' " works bad with NERDTree for example
Plugin 'ryanoasis/vim-devicons'

" surround
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'

" linting
" Plugin 'scrooloose/syntastic'
Plugin 'neomake/neomake'

" git
Plugin 'xuyuanp/nerdtree-git-plugin'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'

" haskell
Plugin 'eagletmt/neco-ghc'
Plugin 'eagletmt/ghcmod-vim'
Plugin 'bitc/lushtags'
Plugin 'twinside/vim-hoogle'
Plugin 'itchyny/vim-haskell-indent'
Plugin 'eagletmt/unite-haddock' " hoogle and haddock for Unite

" faust
Plugin 'gmoe/vim-faust'

" nim
Plugin 'zah/nimrod.vim'

" clojure
Plugin 'clojure-emacs/cider-nrepl'
Plugin 'tpope/vim-fireplace'
Plugin 'kien/rainbow_parentheses.vim'

" asscript
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'flowtype/vim-flow'

" coffee/live-script
Plugin 'kchmck/vim-coffee-script'
Plugin 'gkz/vim-ls'

" typescript
" also: http://vimawesome.com/plugin/typescript-tools
Plugin 'leafgarland/typescript-vim'
" WARNING! requires to run `make` inside `bundle/vimproc.vim` by bare hands!
Plugin 'Shougo/vimproc.vim'
Plugin 'Quramy/tsuquyomi'

" styles
Plugin 'groenewege/vim-less'
Plugin 'wavded/vim-stylus'
Plugin 'ap/vim-css-color'

" markup/data
Plugin 'plasticboy/vim-markdown'
Plugin 'digitaltoad/vim-jade'
Plugin 'briancollins/vim-jst'
Plugin 'chase/vim-ansible-yaml'
Plugin 'elzr/vim-json'
Plugin 'niklasl/vim-rdf'
Plugin 'mattn/emmet-vim'

" configs
Plugin 'nginx.vim'

" colorschemes
Plugin 'morhetz/gruvbox'
Plugin 'tomasr/molokai'
Plugin 'Lokaltog/vim-distinguished'
Plugin 'nanotech/jellybeans.vim'
" also (as files, not packages):
"   - codeschool
"   - railscasts
"   - twilight


" required for vundle
call vundle#end()
filetype plugin indent on

" plugins config
let g:startify_change_to_dir = 0
let g:startify_change_to_vcs_root = 1
let NERDTreeIgnore = ['\.swp', '\.swo', '\.pyc', '__pycache__']
let NERDTreeShowHidden = 1 " always show hidden files in NERDTree
let NERDTreeMapHelp = '<Leader>?' " heals backward search
let NERDTreeShowLineNumbers = 1
let NERDTreeWinSize = 40
let g:nerdtree_tabs_open_on_gui_startup     = 0
let g:nerdtree_tabs_open_on_console_startup = 0
let g:nerdtree_tabs_open_on_new_tab         = 0
let g:tagbar_show_linenumbers               = 2
let g:airline#extensions#tabline#enabled    = 0
let g:airline#extensions#whitespace#enabled = 0
let g:airline_powerline_fonts               = 1
set laststatus=2 " airline always
set hidden " ctrlspace
set showtabline=2
let g:CtrlSpaceDefaultMappingKey = '<C-Space>'
let g:CtrlSpaceUseArrowsInTerm = 1
let g:indentLine_enabled = 0
let g:indent_guides_start_level = 1
let g:indent_guides_auto_colors = 0
let g:indent_guides_enable_on_vim_startup = 0
let g:snipMate = {}
let g:snipMate.scope_aliases = {}
let g:UltiSnipsExpandTrigger = '<Nul>'
let g:UltiSnipsListSnippets  = '<Nul>'
let g:UltiSnipsRemoveSelectModeMappings = 0
" let g:syntastic_enable_signs = 1
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 2
" let g:syntastic_check_on_open = 0
" let g:syntastic_check_on_wq = 0
" let g:syntastic_loc_list_height = 5
" let g:syntastic_enable_highlighting = 0
" let g:syntastic_typescript_checkers = ['tsuquyomi', 'tslint']
" let g:syntastic_python_checkers = ['python']
" let g:syntastic_python_python_exec = '/usr/bin/python3'
let g:flow#enable = 0
let g:indent_guides_exclude_filetypes =
	\ ['help', 'nerdtree', 'tagbar', 'clojure', 'haskell', 'cabal', 'startify']
let g:user_emmet_leader_key = '<C-Z>'
let g:user_emmet_settings = {
	\  'javascript.jsx' : { 'extends' : 'jsx' },
	\  'typescript.jsx' : { 'extends' : 'jsx' },
	\ }
let g:indexed_search_mappings = 0
let g:EasyMotion_do_mapping = 0 " disable default mappings
let g:EasyMotion_smartcase = 1 " turn on case insensitive feature
let g:gitgutter_map_keys = 0
let g:deoplete#enable_at_startup = 1
let g:tsuquyomi_disable_quickfix = 1
let g:necoghc_enable_detailed_browse = 1
let g:WebDevIconsNerdTreeAfterGlyphPadding = ' '
let g:WebDevIconsNerdTreeGitPluginForceVAlign = 1
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:webdevicons_enable_nerdtree = 0 " disabled because it is laggy and buggy
let g:DevIconsEnableFoldersOpenClose = 1
let g:webdevicons_conceal_nerdtree_brackets = 1
let g:unite_source_hoogle_max_candidates = 1000

let g:unite_source_menu_menus = {}
let g:unite_source_menu_menus.ls = { 'description': 'LiveScript/LS' }
let g:unite_source_menu_menus.ls.command_candidates = [
	\ ['Compile selected chunk to JS using LSC', "'<,'>!lsc -cbps | sed 1d"],
	\ ['Get AST from selected chunk using LSC', "'<,'>!lsc -cbpsa"]
	\]
let g:unite_source_menu_menus.haskell = { 'description': 'Haskell' }
let g:unite_source_menu_menus.haskell.command_candidates = [
	\ ['ghc-mod: Get type', 'GhcModType!'],
	\ ['ghc-mod: Get type (redir to @t)',
	\    "redir @t | exec 'GhcModType!' | redir END | echo ''"],
	\ ['ghc-mod: Clear type highlight', 'GhcModTypeClear'],
	\ ['ghc-mod: Insert type', 'GhcModTypeInsert!'],
	\ ['ghc-mod: Check for errors/warnings', 'GhcModCheckAsync!'],
	\ ['ghc-mod: Lint', 'GhcModLintAsync!'],
	\ ['Hoogle (Unite)', 'Unite -auto-resize -start-insert hoogle'],
	\ ['Hoogle (command)', "exec \"let x = input('Hoogle ') | exec 'Hoogle ' . x\""]
	\]
let g:unite_source_menu_menus.unite = { 'description': 'Unite call presets' }
let g:unite_source_menu_menus.unite.command_candidates = [
	\ ['MRU', 'Unite -auto-resize file_mru'],
	\ ['Buffers', 'Unite -auto-resize buffer'],
	\ ['MRU + Buffers (insert)',
	\    'Unite -auto-resize -start-insert file_mru buffer'],
	\ ['Grep by Git files', 'Unite -auto-resize grep/git:.'],
	\ ['Grep by Git files (case insensitive)',
	\    'Unite -auto-resize grep/git:.:-i'],
	\ ['Grep by Git files (bare string)', 'Unite -auto-resize grep/git:.:-F'],
	\ ['Grep by Git files (bare string and case insensitive)',
	\    'Unite -auto-resize grep/git:.:-iF']
	\]
let g:unite_source_menu_menus.view = { 'description': 'View' }
let g:unite_source_menu_menus.view.command_candidates = [
	\ ['Top field',
	\    "exec \"let x = input('Field height: ') | winc n | winc K | se ro"
	\      . "| se noma | se wfh | 9999winc - | let &wh = x | winc p\""],
	\ ['Left field',
	\    "exec \"let x = input('Field width: ') | winc n | winc H | se ro"
	\      . "| se noma | se wfw | 9999winc < | let &wiw = x | winc p\""]
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

try
	call unite#custom#source(
		\ 'file_rec,file_rec/async,file_rec/neovim',
		\ 'ignore_pattern',
		\ '\v\.git/|\.hg/|\.svn/|__pycache__/|node_modules/|bower_components/'
		\   . '\.exe$|\.so$|\.dll$|\.swp$|\.swo$'
		\)
catch
	if stridx(v:exception, ':E117:') == -1
		echoe v:exception
	endif
endtry

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
" try-catch for old vim versions
try
	set breakindentopt=shift:4,sbr
	set breakindent
catch
endtry

set wildmenu

set clipboard-=unnamedplus
set termguicolors

set path+=** " recursively deal with files

call PreventIndentTrimHackOn()

let mapleader = ','

" flying between buffers
" (c) https://bairuidahu.deviantart.com/art/Flying-vs-Cycling-261641977
nnoremap <leader>bl :ls<CR>:b<space>
nnoremap <leader>bd :ls<CR>:bd<space>

nnoremap <leader>r :let @/ = ''<CR>:echo 'Reset search'<CR>

" 'cr' means 'config reload'
nnoremap <leader>cr :source $MYVIMRC<CR>

" nnoremap <leader>n :NERDTreeMirrorToggle<CR>
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>fn :NERDTreeFind<CR>
nnoremap <leader>fo :NERDTreeFind<CR><C-w>p
nnoremap <leader>t :TagbarToggle<CR>
nnoremap <leader>u :GundoToggle<CR>
nnoremap <leader>fb :NERDTreeFind<CR><C-w>p:TagbarOpen<CR>

xmap <Enter> <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" UltiSnips map without conflicts
" with own <Tab> maps for visual and select modes.
if has('python3') || has('python')

	function! s:MyUltiExpand()
		call UltiSnips#isExpandable()
		return g:ulti_is_expandable
	endfunction

	inoremap <expr> <Tab> <SID>MyUltiExpand() ? '<C-R>=UltiSnips#ExpandSnippet()<CR>' : '<Tab>'
endif

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
xnoremap <leader>;  :Unite -auto-resize -start-insert menu:all<CR>
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
nnoremap <leader>mt :AutoTrimSpacesAtEOFToggle<CR>

" some buffer configs
nnoremap <leader>ft :set filetype=
nnoremap <leader>fl :set foldlevel=
nnoremap <leader>fm :set foldmethod=

" some windows things
nnoremap <leader>sww :9999wincmd < \| set winwidth=
nnoremap <leader>swh :9999wincmd - \| set winheight=
nnoremap <leader>swW :set wfw \| 9999wincmd < \| set winwidth=
nnoremap <leader>swH :set wfh \| 9999wincmd - \| set winheight=


" Syntastic
" nnoremap <leader>si :SyntasticInfo<CR>
" nnoremap <leader>sc :SyntasticCheck<CR>
" nnoremap <leader>sr :SyntasticReset<CR>

" Neomake
nnoremap <leader>si :NeomakeInfo<CR>
nnoremap <leader>sc :Neomake<CR>
" nnoremap <leader>sr :<CR>


" show hint
nnoremap <leader>sh :ShowHint<CR>

" short EasyAlign aliases
xnoremap <leader>:  :EasyAlign/:/<CR>
xnoremap <leader>g: :EasyAlign : { 'lm': 0, 'stl': 0 }<CR>
nnoremap <leader>a  :EasyAlign
xnoremap <leader>a  :EasyAlign

" CtrlSF bindings
nmap     <leader>sf <Plug>CtrlSFPrompt
xmap     <leader>sf <Plug>CtrlSFVwordPath
xmap     <leader>sF <Plug>CtrlSFVwordExec
nmap     <leader>sn <Plug>CtrlSFCwordPath
nmap     <leader>sN <Plug>CtrlSFCwordExec
nmap     <leader>sp <Plug>CtrlSFPwordPath
nmap     <leader>sP <Plug>CtrlSFPwordExec
nnoremap <leader>so :CtrlSFOpen<CR>
nnoremap <leader>st :CtrlSFToggle<CR>

" CtrlSpace panel open
nnoremap <C-Space> :CtrlSpace<CR>

" Make Hoogle search easier (because I use it very often)
nnoremap <A-f> :Hoogle<space>
xnoremap <A-f> y:Hoogle <C-R>0<CR>gv


" EasyMotion bindings (<Space> for overwin-mode, <Leader> for current window)

"  L----  ('L' - with <leader> or ' ' - without it)
" QWerty  (uppercase means it have map)
" SS----  ('S' - overwin with <space>)

" move anywhere ('q' means 'quick (move)')
nmap q         <Plug>(easymotion-bd-w)
xmap q         <Plug>(easymotion-bd-w)
nmap <Space>q  <Plug>(easymotion-overwin-w)
" doesn't make sense with 'overwin' mode
xmap <Space>q  <Nop>

" move to place with specific symbols
nmap <leader>w <Plug>(easymotion-bd-f2)
xmap <leader>w <Plug>(easymotion-bd-f2)
nmap <Space>w  <Plug>(easymotion-overwin-f2)
" doesn't make sense with 'overwin' mode
xmap <Space>w  <Nop>

" just another hook as `<leader>e` but for single symbol
nmap <leader>e <Plug>(easymotion-bd-f)
xmap <leader>e <Plug>(easymotion-bd-f)
nmap <Space>e  <Plug>(easymotion-overwin-f)
" doesn't make sense with 'overwin' mode
xmap <Space>e  <Nop>

" LL-L  ('L' - with <leader> or ' ' - without it)
" ZXcV  (uppercase means it have map)
" -S--  ('S' - overwin with <space>)

" move over the line
nmap <leader>z <Plug>(easymotion-lineanywhere)
xmap <leader>z <Plug>(easymotion-lineanywhere)

" move between lines
" (also between empty lines with indentation)
nmap <leader>x <Plug>(easymotion-bd-jk)
xmap <leader>x <Plug>(easymotion-bd-jk)
nmap <Space>x  <Plug>(easymotion-overwin-line)
xmap <Space>x  <Nop>

" turn on visual mode and select to specific place
nmap <leader>v v<Plug>(easymotion-bd-w)
nmap <leader>V V<Plug>(easymotion-bd-jk)

" move by direction
nmap <leader>l <Plug>(easymotion-lineforward)
xmap <leader>l <Plug>(easymotion-lineforward)
nmap <leader>h <Plug>(easymotion-linebackward)
xmap <leader>h <Plug>(easymotion-linebackward)
nmap <leader>j <Plug>(easymotion-j)
xmap <leader>j <Plug>(easymotion-j)
nmap <leader>k <Plug>(easymotion-k)
xmap <leader>k <Plug>(easymotion-k)


" quickhl
nmap <Space>m <Plug>(quickhl-manual-this)
xmap <Space>m <Plug>(quickhl-manual-this)
nmap <Space>M <Plug>(quickhl-manual-reset)
xmap <Space>M <Plug>(quickhl-manual-reset)
nmap <Space>n <Plug>(quickhl-cword-toggle)


" remove word selection symbols after paste from search
nmap <leader>c/ ds\ds>
" plugs to prevent mess about triggering default 'p' or 'P'
map  <leader>p  <Nop>
map  <leader>P  <Nop>
" paste searched word and clean it
map  <leader>p/ '/phds\ds>
map  <leader>P/ '/Phds\ds>

" another alias to system X clipboard
noremap '<Space> "+

" forward version of <C-h> in insert mode
inoremap <C-l> <Del>


" colorscheme stuff
noremap <leader>ss <Esc>:set background=
noremap <leader>sb :BackgroundToggle<CR>
noremap <leader>sB :GruvboxContrastRotate<CR>

nnoremap gy Y:let @0 = substitute(@0, '.', ' ', 'g')<CR>:echo<CR>
nnoremap gY Y:let @0 = substitute(@0, '[^\r\n\t]', ' ', 'g')<CR>:echo<CR>
xnoremap gy y:let @0 = substitute(@0, '.', ' ', 'g')<CR>:echo<CR>
xnoremap gY y:let @0 = substitute(@0, '[^\r\n\t]', ' ', 'g')<CR>:echo<CR>

" hjkl
nnoremap <C-h>     :wincmd h<CR>
xnoremap <C-h>     <Esc>:wincmd h<CR>
nnoremap <C-j>     :wincmd j<CR>
xnoremap <C-j>     <Esc>:wincmd j<CR>
nnoremap <C-k>     :wincmd k<CR>
xnoremap <C-k>     <Esc>:wincmd k<CR>
nnoremap <C-l>     :wincmd l<CR>
xnoremap <C-l>     <Esc>:wincmd l<CR>
" arrow keys
nnoremap <C-Left>  :wincmd h<CR>
xnoremap <C-Left>  <Esc>:wincmd h<CR>
nnoremap <C-Right> :wincmd l<CR>
xnoremap <C-Right> <Esc>:wincmd l<CR>
nnoremap <C-Up>    :wincmd k<CR>
xnoremap <C-Up>    <Esc>:wincmd k<CR>
nnoremap <C-Down>  :wincmd j<CR>
xnoremap <C-Down>  <Esc>:wincmd j<CR>

" walk between windows by alt+arrow keys
nnoremap <A-Left>  zh
xnoremap <A-Left>  zh
nnoremap <A-Right> zl
xnoremap <A-Right> zl
nnoremap <A-Up>    <C-y>
xnoremap <A-Up>    <C-y>
nnoremap <A-Down>  <C-e>
xnoremap <A-Down>  <C-e>

" resizing windows by alt+shift+arrow keys
nnoremap <A-S-Left>  :wincmd <<CR>
xnoremap <A-S-Left>  <Esc>:wincmd <<CR>
nnoremap <A-S-Right> :wincmd ><CR>
xnoremap <A-S-Right> <Esc>:wincmd ><CR>
nnoremap <A-S-Up>    :wincmd +<CR>
xnoremap <A-S-Up>    <Esc>:wincmd +<CR>
nnoremap <A-S-Down>  :wincmd -<CR>
xnoremap <A-S-Down>  <Esc>:wincmd -<CR>

" zoom buffer hack ('fz' means 'full size')
nnoremap <leader>fz :999wincmd ><CR>:999wincmd +<CR>
xnoremap <leader>fz <Esc>:999wincmd ><CR>:999wincmd +<CR>gv

" moving between history in command mode
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" moving tabs
nnoremap <C-S-PageUp>   :tabm-1<CR>
nnoremap <C-S-PageDown> :tabm+1<CR>

" jump by half of screen by pageup/pagedown
nmap <PageUp>     <C-u>
nmap <PageDown>   <C-d>
xmap <PageUp>     <C-u>
xmap <PageDown>   <C-d>
" default jump by pageup/pagedown with shift prefix
nmap <S-PageUp>   <C-b>
nmap <S-PageDown> <C-f>
xmap <S-PageUp>   <C-b>
xmap <S-PageDown> <C-f>

nmap g/        <Plug>(incsearch-easymotion-/)
nmap g?        <Plug>(incsearch-easymotion-?)
nmap <leader>/ <Plug>(incsearch-easymotion-stay)

" get rid off randomly turning ex-mode on
map Q  <Nop>
map gQ <Nop>

" remap macros key under leader
" default 'q' remapped to easymotion call
noremap <leader>q q

inoremap jk <Esc>
cnoremap jk <C-c>
xnoremap <Tab> <Esc>
snoremap <Tab> <Esc>
tnoremap <Leader><Tab> <C-\><C-n>

" thanks to Minoru for the advice
noremap ; :
" noremap : ;

" thanks to r3lgar for the advice (swap default <leader> and comma)
noremap \ ;
noremap \| ,

" because working with clipboard registers is more important
noremap ' "
noremap " '
noremap "" ''

" custom behavior of big R in visual mode
xnoremap R r<Space>R

" break line but keep same column position for rest of the line
imap <A-CR> <Esc>v0gygvo<Esc>li<CR><Esc>#d0i<C-R>0

nnoremap <A-o> mzo<Esc>:let tmp=@"<CR>S<Esc>:let @"=tmp<CR>`z
nnoremap <A-O> mzO<Esc>:let tmp=@"<CR>S<Esc>:let @"=tmp<CR>`z


" custom numbers line keys

nmap ! <Plug>(indexed-search-#)
nnoremap g! yiw:let @/ = '\V\<<C-R>0\>'<CR>:ShowSearchIndex<CR>
xnoremap ! :<C-u>call VisualStarSearchSet('?')<CR>?<C-R>=@/<CR><CR>
xnoremap g! :<C-u>call VisualStarSearchSet('?')<CR>
nmap @ <Plug>(indexed-search-*)
nnoremap g@ yiw:let @/ = '\V\<<C-R>0\>'<CR>:ShowSearchIndex<CR>
xnoremap @ :<C-u>call VisualStarSearchSet('/')<CR>/<C-R>=@/<CR><CR>
xnoremap g@ :<C-u>call VisualStarSearchSet('/')<CR>
" noremap ! #
" noremap @ *

" begin/end of line ignoring indentation and trailing whitespaces
noremap # ^
noremap g# g^
noremap $ g_
noremap g$ g$

" default behavior of %
" noremap %

" noremap ^ 0
" we already have 0, I never use this key (^) this way
" let's remap it to '|' that in case was remapped too
noremap ^ \|
noremap g^ g0

" opposite to 0
noremap & $
noremap g& g$

" macros call
noremap * @
noremap g* g@


" because default maps disabled for plugin
nmap / <Plug>(indexed-search-/)
nmap ? <Plug>(indexed-search-?)
nmap n <Plug>(indexed-search-n)zv
nmap N <Plug>(indexed-search-N)zv

nnoremap <A-t> :tabnew<CR>
nnoremap <A-w> :tabclose<CR>

" quick hook for 'IndentText'
inoremap <A-i> <C-r>=IndentText('')<Left><Left>


" custom digraphs
digraphs '' 769 " accent
digraphs 3. 8230 " dots


" colorscheme

let g:gruvbox_contrast_dark  = 'medium'
let g:gruvbox_contrast_light = 'soft'
set background=dark

if $TMUX == ''
	colorscheme gruvbox
else
	colorscheme twilight
endif


if filereadable('/bin/bash') " gnu/linux
	set shell=/bin/bash
elseif filereadable('/usr/local/bin/bash') " freebsd
	set shell=/usr/local/bin/bash
else
	echoe 'bash interpreter not found'
endif

let $BASH_ENV = $HOME . '/.bash_aliases'


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


" healing conceals in NERDTree
try
	call webdevicons#refresh()
catch
	if stridx(v:exception, ':E117:') == -1
		echoe v:exception
	endif
endtry


" applying local additional config

let g:local_rc_post = $HOME . '/.neovimrc-local-post'

if filereadable(g:local_rc_post)
	exec 'source ' . g:local_rc_post
endif
