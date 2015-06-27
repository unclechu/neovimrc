" clear spaces at EOF and tabs at end of not empty lines
"Author: Viacheslav Lotsmanov

function! ClearSpacesAtEOF()
	try
		exec "%s/\\([^ \\t]\\)[ \\t]\\+$/\\1/g"
		exec "%s/[ ]\\+$//g"
	catch
	endtry
endfunction
command ClearSpacesAtEOF call ClearSpacesAtEOF()

"vim: set noet :
