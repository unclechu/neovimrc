" show hint command
" Author: Viacheslav Lotsmanov
" License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE

function! ShowHint()
	if &filetype =~ '^typescript'
		echo tsuquyomi#hint()
	else
		echo "No hints for '". &filetype ."' filetype"
	endif
endfunction

command! ShowHint call ShowHint()

" vim: set noet :
