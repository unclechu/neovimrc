" relative number toggle
" Author: Viacheslav Lotsmanov
" License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE

function! RelativeNumberToggle()
	let &relativenumber = ! &relativenumber
	echo 'Relative numbers is ' . (&relativenumber ? 'enabled' : 'disabled')
endfunction

command! RelativeNumberToggle call RelativeNumberToggle()

" vim: set noet :
