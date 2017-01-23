" wrap toggle
" Author: Viacheslav Lotsmanov

function! WrapToggle()
	let &wrap = ! &wrap
	if &wrap
		echo 'Wrap mode is enabled'
	else
		echo 'Wrap mode is disabled'
	endif
endfunction

command! WrapToggle call WrapToggle()

" vim: set noet :
