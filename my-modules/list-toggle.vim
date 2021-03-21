" list toggle
" Author: Viacheslav Lotsmanov
" License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE

function! ListToggle()
	let &list = ! &list
	echo 'Special chars highlighting is ' . (&list ? 'enabled' : 'disabled')
endfunction

command! ListToggle call ListToggle()

" vim: set noet :
