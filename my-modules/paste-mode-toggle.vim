" paste mode toggle
" Author: Viacheslav Lotsmanov
" License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE

function! PasteToggle()
	let &paste = ! &paste
	echo 'Paste mode is ' . (&paste ? 'enabled' : 'disabled')
endfunction

command! PasteToggle call PasteToggle()

" vim: set noet :
