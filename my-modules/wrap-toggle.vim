" wrap toggle
" Author: Viacheslav Lotsmanov

function! WrapToggle()
	let &wrap = ! &wrap
	echo 'Wrap mode is ' . (&wrap ? 'enabled' : 'disabled')
endfunction

command! WrapToggle call WrapToggle()

" vim: set noet :
