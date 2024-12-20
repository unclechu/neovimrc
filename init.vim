" NeoVim config
" Author: Viacheslav Lotsmanov
" License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE
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


" my own options

let g:insert_leave_autosave_enabled = 0


" colorscheme

let g:gruvbox_contrast_dark  = 'medium'
let g:gruvbox_contrast_light = 'soft'
set background=dark

" Switch to light colorscheme if detected my Tmux session in light colorscheme
if $TMUX != '' && executable('tmuxsh')
\&& substitute(system('tmuxsh co s'), '\n\+$', '', '') == 'light'
	se bg=light
en

" Check if a colorscheme is available
fu! s:HasColorscheme(name)
	retu filereadable(globpath(&rtp, 'colors/' . a:name . '.vim'))
endf

" “gruvbox” and some other colorschemes are slightly broken in Neovim 0.10.
" This “retrobox” is basically builtin “gruvbox” colorscheme but in single
" contrast mode. But the important part is that it’s not broken.
if s:HasColorscheme('retrobox')
	Colorscheme retrobox
elsei s:HasColorscheme('gruvbox')
	Colorscheme gruvbox
el
	" None of the above colorschemes found.
	" Doing just nothing, assuming it’s a non-Nix setup and the plugins are not
	" installed yet.
en


" Neovim shell (&sh) configuration

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
