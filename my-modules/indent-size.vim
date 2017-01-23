" indent size
" Author: Viacheslav Lotsmanov

function! TabsIndentSize(size)
	set noet
	let &ts  = a:size
	let &sts = a:size
	let &sw  = a:size
	IndentGuidesToggle
	IndentGuidesToggle
endfunction

function! SpacesIndentSize(size)
	set et
	let &ts  = a:size
	let &sts = a:size
	let &sw  = a:size
	IndentGuidesToggle
	IndentGuidesToggle
endfunction

command! -nargs=1 TabsIndentSize   call TabsIndentSize(<f-args>)
command! -nargs=1 SpacesIndentSize call SpacesIndentSize(<f-args>)

" vim: set noet :
