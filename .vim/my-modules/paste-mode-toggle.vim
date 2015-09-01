" paste mode toggle
"Author: Viacheslav Lotsmanov

function! PasteToggle()
	let &paste = ! &paste
endfunction

command! PasteToggle call PasteToggle()

"vim: set noet :
