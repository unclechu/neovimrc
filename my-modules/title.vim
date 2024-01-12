" Window title configuration (primarily for GUI).
"
" Author: Viacheslav Lotsmanov
" License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE

" You can customize window title prefix by setting “NVIM_TITLE_PFX” environment
" variable like this:
"
"   env NVIM_TITLE_PFX=Foo neovide
"
" This can be useful for fuzzy-search navigation by window title
" (e.g. when using “rofi -show window”).
"
" You can also set or change the prefix during runtime like this:
"
"   let $NVIM_TITLE_PFX = 'Foo Bar'
"
" Or by using special command:
"
"   TitlePrefix Foo Bar
"

let &titlestring
	\ = "%{$NVIM_TITLE_PFX}%{($NVIM_TITLE_PFX == '') ? '' : ' — '}"
	\ . "%{expand('%')}%{expand('%') == '' ? '' : ' '}(%{getcwd()})"
	\ . "%{$NVIM_TITLE_PFX != '' ? '' : ' — Neovim'}"

" Turn the title feature on
set title

" Title length limit
set titlelen=120

" Set/change the window title prefix
fun! s:set_title_prefix(title)
	if a:title == ''
		unl $NVIM_TITLE_PFX
	el
		let $NVIM_TITLE_PFX = a:title
	en
endf

" A special command for setting/changing window title prefix.
" Just call “TitlePrefix” with no arguments to remove the prefix.
com! -nargs=? TitlePrefix cal <SID>set_title_prefix(<q-args>)

" vim: set noet :
