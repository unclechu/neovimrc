" NeoVim config
" Author: Viacheslav Lotsmanov
" vim: set noet fenc=utf-8 :


" applying local additional config
let g:local_rc_pre = $HOME . '/.neovimrc-local-pre'
if filereadable(g:local_rc_pre) | exe 'so ' . g:local_rc_pre | en


let $MYVIMRC_DIR = fnamemodify($MYVIMRC, ':h')

exe 'so ' . $MYVIMRC_DIR . '/plugins.vim'
exe 'so ' . $MYVIMRC_DIR . '/plugins-configs.vim'

" load my modules
for module in split(expand($MYVIMRC_DIR . '/my-modules/**/*.vim'), '\n')
	exe 'so ' . module
endfo

exe 'so ' . $MYVIMRC_DIR . '/options.vim'
cal PreventIndentTrimHackOn()
exe 'so ' . $MYVIMRC_DIR . '/maps.vim'


" colorscheme

let g:gruvbox_contrast_dark  = 'medium'
let g:gruvbox_contrast_light = 'soft'
set background=dark

try
	if $TMUX != '' &&
	\ substitute(system('tmuxsh co s'), '\n\+$', '', '') == 'light'
		se bg=light
	en

	Colorscheme gruvbox
cat
	" colorscheme not found (plugins are not installed yet)
	if stridx(v:exception, ':E185:') == -1 | echoe v:exception | en
endt


let s:sh
	\ = (fnamemodify($SHELL, ':t') =~ 'bash')
	\ ? systemlist('which -- '.shellescape($SHELL))[0]
	\ : ''

if filereadable(s:sh)
	let &sh = s:sh
el
	let s:sh = systemlist('which bash')[0]

	if filereadable(s:sh)
		let &sh = s:sh
	el
		echoe 'bash interpreter not found'
	en
en

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


" applying local additional config
let g:local_rc_post = $HOME . '/.neovimrc-local-post'
if filereadable(g:local_rc_post) | exe 'so ' . g:local_rc_post | en
