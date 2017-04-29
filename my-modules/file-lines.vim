" get file lines for CLI
" Author: Viacheslav Lotsmanov

" python wrapper
function! s:pybase64enc(to_encode)
	let l:encoded = ''
	python <<EOF
import vim
import base64
to_encode = vim.eval('a:to_encode')
encoded = base64.b64encode(to_encode)
vim.command("let l:encoded = '"+ encoded +"'")
EOF
	return l:encoded
endfunction

" shows selected lines in shell (for terminal copy-paste)
function! s:filelines() range
	let l:to_encode = ''

	for l:linenum in range(a:firstline, a:lastline)
		if l:linenum > a:firstline
			let l:to_encode = to_encode . "\n"
		endif

		let l:to_encode = l:to_encode . getline(l:linenum)
	endfor

	exec ":!echo '" . s:pybase64enc(l:to_encode) . "' | base64 --decode"
endfunction

command! -range FileLines <line1>,<line2>call s:filelines()

" vim: set noet :
