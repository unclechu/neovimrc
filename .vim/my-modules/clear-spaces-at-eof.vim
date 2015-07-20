" clear spaces at EOF and tabs at end of not empty lines
"Author: Viacheslav Lotsmanov

function! ClearSpacesAtEOF()
	
	" clear spaces and tabs at EOF of not empty lines
	
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
		
		if s:line =~ '\([^ \t]\)[ \t]\+$' && s:isoc == 0
			call setline(
				\ s:i,
				\ substitute(s:lineorig, '\([^ \t]\)[ \t]\+$', '\1', '')
			\ )
		endif
	endwhile
	
	" clear all spaces at EOF if we using tabs for indentation
	try
		if ! &expandtab
			silent %s/[ ]\+$//g
		endif
	catch
	endtry
	
	" clear tabs after spaces if we using tabs for indentation
	try
		if ! &expandtab
			silent %s/[ ]\+[ \t]\+$//g
		endif
	catch
	endtry
	
endfunction
command ClearSpacesAtEOF call ClearSpacesAtEOF()

"vim: set noet :
