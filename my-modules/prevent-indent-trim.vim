" dirty hacks for prevent unwanted trim trailing whitespace
" Author: Viacheslav Lotsmanov

function! PreventIndentTrimHackOn()
	inoremap <CR> x<Backspace><CR>x<Backspace>
	inoremap <C-j> x<Backspace><C-j>x<Backspace>
	nnoremap o ox<Backspace>
	nnoremap O Ox<Backspace>
	nnoremap cc ccx<Backspace>
	xnoremap c cx<Backspace>
	xnoremap C Cx<Backspace>

	"taken by easymotion
	"nnoremap s sx<Backspace

	nnoremap S Sx<Backspace>

	"taken by easymotion
	"xnoremap s sx<Backspace>

	"surround plugin need it
	"xnoremap S Sx<Backspace>
endfunction

function! PreventIndentTrimHackOff()
	try
		iunmap <CR>
		iunmap <C-j>
		nunmap o
		nunmap O
		nunmap cc
		xunmap c
		xunmap C

		"taken by easymotion
		"nunmap s

		nunmap S

		"taken by easymotion
		"xunmap s

		"surround plugin need it
		"xunmap S
	catch
	endtry
endfunction

command! PreventIndentTrimHackOn  call PreventIndentTrimHackOn()
command! PreventIndentTrimHackOff call PreventIndentTrimHackOff()

if !exists('s:loaded')
	autocmd CmdwinEnter * call PreventIndentTrimHackOff()
	autocmd CmdwinLeave * call PreventIndentTrimHackOn()
	let s:loaded = 1
endif

" vim: set noet :
