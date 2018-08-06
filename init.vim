" NeoVim config
" Author: Viacheslav Lotsmanov
" vim: set noet fenc=utf-8 :


" applying local additional config
let g:local_rc_pre = $HOME . '/.neovimrc-local-pre'
if filereadable(g:local_rc_pre) | exec 'so ' . g:local_rc_pre | endif


let $MYVIMRC_DIR = fnamemodify($MYVIMRC, ':h')

exec 'source ' . $MYVIMRC_DIR . '/plugins.vim'
exec 'source ' . $MYVIMRC_DIR . '/plugins-configs.vim'
exec 'source ' . $MYVIMRC_DIR . '/menu.vim'

" load my modules
for module in split(expand($MYVIMRC_DIR . '/my-modules/**/*.vim'), '\n')
	exec 'source ' . module
endfor

exec 'source ' . $MYVIMRC_DIR . '/options.vim'
call PreventIndentTrimHackOn()
exec 'source ' . $MYVIMRC_DIR . '/maps.vim'


" colorscheme

let g:gruvbox_contrast_dark  = 'medium'
let g:gruvbox_contrast_light = 'soft'
set background=dark

try
	if $TMUX == ''
		colo gruvbox
	el
		colo one
		if substitute(system('tmuxsh co s'), '\n\+$', '', '') == 'light'
			se bg=light
		el
			se bg=dark
		en
	en

	call g:ColorschemeCustomizations()
cat
	" colorscheme not found (plugins are not installed yet)
	if stridx(v:exception, ':E185:') == -1 | echoe v:exception | endif
endt


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
	if stridx(v:exception, ':E117:') == -1 | echoe v:exception | endif
endtry


" applying local additional config
let g:local_rc_post = $HOME . '/.neovimrc-local-post'
if filereadable(g:local_rc_post) | exec 'so ' . g:local_rc_post | endif
