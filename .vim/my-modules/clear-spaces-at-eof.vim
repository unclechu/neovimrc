" clear spaces at EOF and tabs at end of not empty lines
"Author: Viacheslav Lotsmanov

function! ClearSpacesAtEOF()
	try
		exec "%s/\\([^ \\t]\\)[ \\t]\\+$/\\1/g"
	catch
	endtry
	try
		if ! &expandtab
			exec "%s/[ ]\\+$//g"
		endif
	catch
	endtry
endfunction
command ClearSpacesAtEOF call ClearSpacesAtEOF()

"vim: set noet :
