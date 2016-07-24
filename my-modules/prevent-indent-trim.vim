"dirty hacks for prevent unwanted trim trailing whitespace
"Author: Viacheslav Lotsmanov

function! PreventIndentTrimHackOn()
	inoremap <CR> x<Backspace><CR>x<Backspace>
	inoremap <C-j> x<Backspace><C-j>x<Backspace>
	nnoremap o ox<Backspace>
	nnoremap O Ox<Backspace>
	nnoremap cc ccx<Backspace>
	vnoremap c cx<Backspace>
	vnoremap C Cx<Backspace>
	nnoremap s sx<Backspace>
	nnoremap S Sx<Backspace>
	vnoremap s sx<Backspace>
	"surround plugin need it
	"vnoremap S Sx<Backspace>
endfunction

function! PreventIndentTrimHackOff()
	try
		iunmap <CR>
		iunmap <C-j>
		nunmap o
		nunmap O
		nunmap cc
		vunmap c
		vunmap C
		nunmap s
		nunmap S
		vunmap s
		"surround plugin need it
		"vunmap S
	catch
	endtry
endfunction

command! PreventIndentTrimHackOn  call PreventIndentTrimHackOn()
command! PreventIndentTrimHackOff call PreventIndentTrimHackOff()

if has('autocmd')
	autocmd CmdwinEnter * call PreventIndentTrimHackOff()
	autocmd CmdwinLeave * call PreventIndentTrimHackOn()
endif

"vim: set noet :
