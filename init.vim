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

call InitializeColorscheme()


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

" applying local additional config
let g:local_rc_post = $HOME . '/.neovimrc-local-post'
if filereadable(g:local_rc_post) | exe 'so ' . g:local_rc_post | en
