" clear spaces at EOF and tabs at end of not empty lines
"Author: Viacheslav Lotsmanov

let g:auto_clear_spaces_at_eof = 1

function! ClearSpacesAtEOF(doItAnyway)
	
	" clear spaces and tabs at EOF of not empty lines
	
	if g:auto_clear_spaces_at_eof == 0 && a:doItAnyway == 0
		return
	endif
	
	let oldPosLine = line('.')
	let oldPosCol  = col('.')
	
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
			
			let s:hasComments = 1
			
			" /* */ comments
			while s:hasComments == 1
				let s:hasComments = 0
				if s:isoc == 0
					if s:line =~ '/\*'
						let s:hasComments = 1
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
						let s:hasComments = 1
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
		try
			silent %s/[ ]\+$//g
		catch
		endtry
	endif
	
	" clear tabs after spaces if we using tabs for indentation
	if ! &expandtab
		try
			silent %s/[ ]\+[ \t]\+$//g
		catch
		endtry
	endif
	
	call cursor(oldPosLine, oldPosCol)
	
endfunction

function! AutoClearSpacesAtEOF(status)
	if a:status == -1 " toggle
		if g:auto_clear_spaces_at_eof == 0
			call AutoClearSpacesAtEOF(1)
		else
			call AutoClearSpacesAtEOF(0)
		endif
	elseif a:status == 0 " disable
		let g:auto_clear_spaces_at_eof = 0
		echo 'Auto clear spaces at EOF is disabled'
	elseif a:status == 1 " enable
		let g:auto_clear_spaces_at_eof = 1
		echo 'Auto clear spaces at EOF is enabled'
	endif
endfunction

command! AutoClearSpacesAtEOFToggle  call AutoClearSpacesAtEOF(-1)
command! AutoClearSpacesAtEOFEnable  call AutoClearSpacesAtEOF(1)
command! AutoClearSpacesAtEOFDisable call AutoClearSpacesAtEOF(0)

command! ClearSpacesAtEOF call ClearSpacesAtEOF(1)

if has('autocmd')
	autocmd BufWritePre * call ClearSpacesAtEOF(0)
endif

"vim: set noet :
