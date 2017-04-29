" paste mode toggle
" Author: Viacheslav Lotsmanov

function! PasteToggle()
	let &paste = ! &paste
	echo 'Paste mode is ' . (&paste ? 'enabled' : 'disabled')
endfunction

command! PasteToggle call PasteToggle()

" vim: set noet :
