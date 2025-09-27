" Author: Viacheslav Lotsmanov
" License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE

" A small simple plugin for interactively selecting a colorscheme and previewing
" it on the fly.
"
" :ColorschemePicker
" :ColorschemePickerFav
"
" ↑ These depend on `g:colorschemes` and `g:colorschemes_fav` defined in
"   `colorscheme.vim`.
"
" Also there is a dependency on `:Colorscheme` command.

" No need really, when commented it makes it easier to live-reload the module.
"if exists('g:loaded_colorscheme_picker')
"	finish
"endif
"let g:loaded_colorscheme_picker = 1

" Public commands
" Full list from g:colorschemes (or empty if missing).
command! ColorschemePicker call s:ColorschemePickerOpen(get(g:, 'colorschemes', []))

" Favorites = intersection of g:colorschemes and g:colorschemes_fav.
command! ColorschemePickerFav call s:ColorschemePickerOpen(s:Intersect(get(g:, 'colorschemes', []), get(g:, 'colorschemes_fav', [])))

function! s:Intersect(all, fav) abort
	if type(a:all) != type([]) || type(a:fav) != type([])
		return []
	endif
	" Fast membership test via dict set built from 'all'
	let l:has = {}
	for l:x in a:all
		let l:has[l:x] = 1
	endfor
	" Keep favorites order, drop non-overlapping
	return filter(copy(a:fav), 'has_key(l:has, v:val)')
endfunction

" Open picker for a provided list of scheme names.
function! s:ColorschemePickerOpen(items) abort
	" Validate input list
	if type(a:items) != type([]) || empty(a:items)
		echo "(ColorschemePicker: empty list)"
		return
	endif

	" Scratch split
	botright 20vsplit
	enew
	setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
	setlocal nowrap nonumber norelativenumber signcolumn=no foldcolumn=0 cursorline

	" Populate
	setlocal modifiable
	call setline(1, a:items)
	setlocal nomodifiable

	" Mappings
	nnoremap <silent><buffer> q :close<CR>
	nnoremap <silent><buffer> <CR> :<C-u>call <SID>ApplyColorschemeUnderCursor(1)<CR>

	" Live preview on move (buffer-local)
	augroup ColorschemePicker
		autocmd! * <buffer>
		autocmd CursorMoved <buffer> call <SID>ApplyColorschemeUnderCursor(0)
	augroup END

	" Initial preview
	call <SID>ApplyColorschemeUnderCursor(0)
endfunction

function! s:ApplyColorschemeUnderCursor(close_after) abort
	let l:ln = getline('.')
	if empty(l:ln)
		return
	endif
	" Safe apply; ignore missing schemes
	try
		execute 'Colorscheme ' . l:ln
	catch /^Vim\%((\a\+)\)\=:/
		" swallow errors like E185
	endtry
	if a:close_after
		close
	endif
endfunction
