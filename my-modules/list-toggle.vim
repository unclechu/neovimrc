" list toggle
" Author: Viacheslav Lotsmanov

function! ListToggle()
	let &list = ! &list
	echo 'Special chars highlighting is ' . (&list ? 'enabled' : 'disabled')
endfunction

command! ListToggle call ListToggle()

" vim: set noet :
