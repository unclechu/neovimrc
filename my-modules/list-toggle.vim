" list toggle
" Author: Viacheslav Lotsmanov

function! ListToggle()
	let &list = ! &list
	if &list
		echo 'Special chars highlighting is enabled'
	else
		echo 'Special chars highlighting is disabled'
	endif
endfunction

command! ListToggle call ListToggle()

" vim: set noet :
