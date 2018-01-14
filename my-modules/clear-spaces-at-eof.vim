" clear spaces at EOF and tabs at end of not empty lines
" Author: Viacheslav Lotsmanov

if !exists('s:loaded')
	let g:auto_clear_spaces_at_eof = 1 " for non empty lines
	let g:auto_trim_spaces_at_eof  = 0 " for every line
endif


" clear spaces and tabs at EOF of not empty lines
function! s:ClearSpacesAtEOF(do_it_anyway)

	if g:auto_clear_spaces_at_eof == 0 && a:do_it_anyway == 0
		return
	endif

	let l:view = winsaveview()
	let l:i    = 0 " current line
	let l:c    = line('$') " lines count
	let l:isoc = 0 " is multiline comment opened

	while l:i < l:c

		let l:i        = l:i + 1
		let l:line     = getline(l:i)
		let l:lineorig = l:line " original line contents (immutable variable)

		if   &filetype == 'javascript'
		\ || &filetype == 'ls'

			let l:has_comments = 1

			" /* */ comments
			while l:has_comments == 1
				let l:has_comments = 0

				if l:isoc == 0
					if l:line =~ '/\*'
						let l:has_comments = 1
						let l:isoc = 1

						let l:linesub = substitute(
							\ l:line, '^.\{-}/\*.\{-}\*/', 'x', ''
						\ )

						" if previous regex didn't match
						if l:linesub == l:line
							let l:line = ''
						else
							let l:line = l:linesub
							let l:isoc = 0
						endif
					endif
				else
					if l:line =~ '\*/'
						let l:has_comments = 1
						let l:isoc = 0
						let l:line = substitute(l:line, '^.\{-}\*/', 'x', '')
					endif
				endif
			endwhile

			if &filetype == 'ls'
				" # comments
				let l:line = substitute(l:line, '[ \t]*#.*$', '', '')
			else " javascript
				" // comments
				let l:line = substitute(l:line, '[ \t]*//.*$', '', '')
			endif
		endif

		if l:isoc == 0 && l:line =~ '\([^ \t]\)[ \t]\+$'
			call setline(
				\ l:i,
				\ substitute(l:lineorig, '\([^ \t]\)[ \t]\+$', '\1', '')
			\ )
		endif
	endwhile

	" clear all spaces at EOF if we using tabs for indentation
	if ! &expandtab
		silent %s/[ ]\+$//ge
	endif

	" clear tabs after spaces if we using tabs for indentation
	if ! &expandtab
		silent %s/[ ]\+[ \t]\+$//ge
	endif

	call winrestview(l:view)

endfunction

function! s:AutoClearSpacesAtEOF(status)
	if a:status == -1 " toggle
		if g:auto_clear_spaces_at_eof == 0
			call s:AutoClearSpacesAtEOF(1)
		else
			call s:AutoClearSpacesAtEOF(0)
		endif
	elseif a:status == 0 " disable
		let g:auto_clear_spaces_at_eof = 0
		echo 'Auto clear spaces at EOF is disabled'
	elseif a:status == 1 " enable
		let g:auto_clear_spaces_at_eof = 1
		echo 'Auto clear spaces at EOF is enabled'
	endif
endfunction

command! AutoClearSpacesAtEOFToggle  call s:AutoClearSpacesAtEOF(-1)
command! AutoClearSpacesAtEOFEnable  call s:AutoClearSpacesAtEOF(1)
command! AutoClearSpacesAtEOFDisable call s:AutoClearSpacesAtEOF(0)
command! ClearSpacesAtEOF call s:ClearSpacesAtEOF(1)


" clear any space characters at EOF for every line
function! s:TrimSpacesAtEOF(do_it_anyway)

	if g:auto_trim_spaces_at_eof == 0 && a:do_it_anyway == 0
		return
	endif

	let l:view = winsaveview()
	silent %s/\s\+$//e
	call winrestview(l:view)

endfunction

function! s:AutoTrimSpacesAtEOF(status)
	if a:status == -1 " toggle
		if g:auto_trim_spaces_at_eof == 0
			call s:AutoTrimSpacesAtEOF(1)
		else
			call s:AutoTrimSpacesAtEOF(0)
		endif
	elseif a:status == 0 " disable
		let g:auto_trim_spaces_at_eof = 0
		echo 'Auto trim spaces at EOF is disabled'
	elseif a:status == 1 " enable
		let g:auto_trim_spaces_at_eof = 1
		echo 'Auto trim spaces at EOF is enabled'
	endif
endfunction

command! AutoTrimSpacesAtEOFToggle  call s:AutoTrimSpacesAtEOF(-1)
command! AutoTrimSpacesAtEOFEnable  call s:AutoTrimSpacesAtEOF(1)
command! AutoTrimSpacesAtEOFDisable call s:AutoTrimSpacesAtEOF(0)
command! TrimSpacesAtEOF            call s:TrimSpacesAtEOF(1)


if !exists('s:loaded')
	autocmd BufWritePre * call s:ClearSpacesAtEOF(0)
	autocmd BufWritePre * call s:TrimSpacesAtEOF(0)
endif

let s:loaded = 1

" vim: set noet :
