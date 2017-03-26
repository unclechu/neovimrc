" Author: Viacheslav Lotsmanov

function! XClipYank()
	let l:data = join(getline(a:firstline, a:lastline), "\n")
	call system('xclip -i -selection clipboard', l:data)
endfunction

function! XClipPaste()
	read !xclip -o -selection clipboard
endfunction

function! XClipGet()
	let @@ = system('xclip -o -selection clipboard')
endfunction

function! XClipPut()
	call system('xclip -i -selection clipboard', @@)
endfunction

command! -range -nargs=0 XClipYank <line1>,<line2>call XClipYank()
command! -nargs=0 XClipPaste call XClipPaste()
command! -nargs=0 XClipGet call XClipGet()
command! -nargs=0 XClipPut call XClipPut()
