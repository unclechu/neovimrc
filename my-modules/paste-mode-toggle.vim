" paste mode toggle
"Author: Viacheslav Lotsmanov

function! PasteToggle()
	let &paste = ! &paste
	if &paste
		echo 'Paste mode is enabled'
	else
		echo 'Paste mode is disabled'
	endif
endfunction

command! PasteToggle call PasteToggle()

"vim: set noet :
