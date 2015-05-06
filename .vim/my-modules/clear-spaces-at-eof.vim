"clear spaces at EOF
"Author: Viacheslav Lotsmanov

function! ClearSpacesAtEOF()
	try
		exec "%s/[ ]\\+$//g"
	catch
	endtry
endfunction
command ClearSpacesAtEOF call ClearSpacesAtEOF()

"vim: set noet :
