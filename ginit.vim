" Author: Viacheslav Lotsmanov

" because default map doesn't work in nvim-qt
nnoremap <C-Space> :CtrlSpace<CR>


GuiFont Hack:h9
" call rpcnotify(1, 'Gui', 'Font', 'Hack 9')


" fast font inc/dec

function! s:get_font_data()
	return {
		\ 'face': substitute(g:GuiFont, '^\(.\+:h\)[0-9]\+$', '\1', 'g'),
		\ 'size': 0 + substitute(g:GuiFont, '^.\+:h\([0-9]\+\)$', '\1', 'g')
	\ }
endfunction

function! s:font_size_dec(count)
	let l:font = s:get_font_data()
	let l:count = a:count
	if l:count < 1
		let l:count = 1
	endif
	let l:newsize = l:font.size - l:count
	if l:newsize < 1
		let l:newsize = 1
	endif
	exec 'GuiFont ' . l:font.face . l:newsize
endfunction

function! s:font_size_inc(count)
	let l:font = s:get_font_data()
	let l:count = a:count
	if l:count < 1
		let l:count = 1
	endif
	let l:newsize = l:font.size + l:count
	if l:newsize < 1
		let l:newsize = 1
	endif
	exec 'GuiFont ' . l:font.face . l:newsize
endfunction

command! GuiFontSizeDec call <SID>font_size_dec(1)
command! GuiFontSizeInc call <SID>font_size_inc(1)
command! -nargs=1 GuiFontSizeDecN call <SID>font_size_dec(<args>)
command! -nargs=1 GuiFontSizeIncN call <SID>font_size_inc(<args>)

nnoremap <leader>- :<C-u>call <SID>font_size_dec(v:count)<CR>
nnoremap <leader>+ :<C-u>call <SID>font_size_inc(v:count)<CR>
nnoremap <leader>= :<C-u>call <SID>font_size_inc(v:count)<CR>
