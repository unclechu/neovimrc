" show hint command
" Author: Viacheslav Lotsmanov

function! ShowHint()
	if &filetype =~ '^typescript'
		echo tsuquyomi#hint()
	else
		echo "No hints for '". &filetype ."' filetype"
	endif
endfunction

command! ShowHint call ShowHint()

" vim: set noet :
