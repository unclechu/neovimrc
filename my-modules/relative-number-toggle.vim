" relative number toggle
" Author: Viacheslav Lotsmanov

function! RelativeNumberToggle()
	let &relativenumber = ! &relativenumber
	echo 'Relative numbers is ' . (&relativenumber ? 'enabled' : 'disabled')
endfunction

command! RelativeNumberToggle call RelativeNumberToggle()

" vim: set noet :
