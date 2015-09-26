"auto surround input
"Author: Viacheslav Lotsmanov

function! PutAsIs()
	let symbol = input('Put as is: ')
	return symbol
endfunction

imap \ <C-R>=PutAsIs()<CR>

function! IsAutoSurroundInputEnabled()
	return mapcheck("{", "i") == '<C-G>s{'
endfunction

function! AutoSurroundInputEnable(silent)
	
	if IsAutoSurroundInputEnabled()
		
		if ! a:silent
			echo 'Auto surround input enabled already'
		endif
		
		return
	endif
	
	imap { <C-G>s{
	imap } <C-G>s}
	
	imap [ <C-G>s[
	imap ] <C-G>s]
	
	imap ( <C-G>s(
	imap ) <C-G>s)
	
	imap < <C-G>s<
	imap > <C-G>s>
	
	imap ' <C-G>s'
	imap " <C-G>s"
	
	if ! a:silent
		echo 'Auto surround input enabled'
	endif
	
endfunction

function! AutoSurroundInputDisable(silent)
	
	if ! IsAutoSurroundInputEnabled()
		
		if ! a:silent
			echo 'Auto surround input disabled already'
		endif
		
		return
	endif
	
	iunmap {
	iunmap }
	
	iunmap [
	iunmap ]
	
	iunmap (
	iunmap )
	
	iunmap <
	iunmap >
	
	iunmap '
	iunmap "
	
	if ! a:silent
		echo 'Auto surround input disabled'
	endif
	
endfunction

function! AutoSurroundInputToggle(silent)
	if IsAutoSurroundInputEnabled()
		call AutoSurroundInputDisable(a:silent)
	else
		call AutoSurroundInputEnable(a:silent)
	endif
endfunction

command! AutoSurroundInputEnable  call AutoSurroundInputEnable(0)
command! AutoSurroundInputDisable call AutoSurroundInputDisable(0)
command! AutoSurroundInputToggle  call AutoSurroundInputToggle(0)

"vim: set noet :
