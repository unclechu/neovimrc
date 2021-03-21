" wrap toggle
" Author: Viacheslav Lotsmanov
" License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE

function! WrapToggle()
	let &wrap = ! &wrap
	echo 'Wrap mode is ' . (&wrap ? 'enabled' : 'disabled')
endfunction

command! WrapToggle call WrapToggle()

" vim: set noet :
