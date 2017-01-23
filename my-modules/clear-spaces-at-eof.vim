" clear spaces at EOF and tabs at end of not empty lines
" Author: Viacheslav Lotsmanov



let g:auto_clear_spaces_at_eof = 1 " for non empty lines
let g:auto_trim_spaces_at_eof  = 0 " for every line



" clear spaces and tabs at EOF of not empty lines
function! s:ClearSpacesAtEOF(do_it_anyway)
	
	if g:auto_clear_spaces_at_eof == 0 && a:do_it_anyway == 0
		return
	endif
	
	let s:view = winsaveview()
	
	" current line
	let s:i = 0
	" lines count
	let s:c = line('$')
	" is multiline comment opened
	let s:isoc = 0
	
	while s:i < s:c
		
		let s:i        = s:i + 1
		let s:line     = getline(s:i)
		let s:lineorig = s:line
		
		if   &filetype == 'javascript'
		\ || &filetype == 'ls'
			
			let s:has_comments = 1
			
			" /* */ comments
			while s:has_comments == 1
				let s:has_comments = 0
				if s:isoc == 0
					if s:line =~ '/\*'
						let s:has_comments = 1
						let s:isoc = 1
						let s:linesub = substitute(
							\ s:line,
							\ '^.\{-}/\*.\{-}\*/', 'x', '')
						" if previous regex didn't match
						if s:linesub == s:line
							let s:line = ''
						else
							let s:line = s:linesub
							let s:isoc = 0
						endif
					endif
				else
					if s:line =~ '\*/'
						let s:has_comments = 1
						let s:isoc = 0
						let s:line = substitute(s:line, '^.\{-}\*/', 'x', '')
					endif
				endif
			endwhile
			
			if &filetype == 'ls'
				" # comments
				let s:line = substitute(s:line, '[ \t]*#.*$', '', '')
			else "javascript
				" // comments
				let s:line = substitute(s:line, '[ \t]*//.*$', '', '')
			endif
		endif
		
		if s:isoc == 0 && s:line =~ '\([^ \t]\)[ \t]\+$'
			call setline(
				\ s:i,
				\ substitute(s:lineorig, '\([^ \t]\)[ \t]\+$', '\1', '')
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
	
	call winrestview(s:view)
	
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
	
	let s:view = winsaveview()
	silent %s/\s\+$//e
	call winrestview(s:view)
	
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

command! TrimSpacesAtEOF call s:TrimSpacesAtEOF(1)



if has('autocmd')
	autocmd BufWritePre * call s:ClearSpacesAtEOF(0)
	autocmd BufWritePre * call s:TrimSpacesAtEOF(0)
endif



" vim: set noet :
