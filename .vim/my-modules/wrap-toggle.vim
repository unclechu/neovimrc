" wrap toggle
"Author: Viacheslav Lotsmanov

function! WrapToggle()
	let &wrap = ! &wrap
endfunction

command! WrapToggle call WrapToggle()

"vim: set noet :
