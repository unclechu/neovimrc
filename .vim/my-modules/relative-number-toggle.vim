" relative number toggle
"Author: Viacheslav Lotsmanov

function! RelativeNumberToggle()
	let &relativenumber = ! &relativenumber
	if &relativenumber
		echo 'Relative numbers is enabled'
	else
		echo 'Relative numbers is disabled'
	endif
endfunction

command! RelativeNumberToggle call RelativeNumberToggle()

"vim: set noet :
