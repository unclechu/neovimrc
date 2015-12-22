"auto surround input
"Author: Viacheslav Lotsmanov

let g:surround_insert_tail = ''
let s:surround_insert_tail__old_val = ''


function! StoreOldSurroundTail()
	let s:surround_insert_tail__old_val = g:surround_insert_tail
	return ''
endfunction

function! RestoreSurroundTail()
	let g:surround_insert_tail = s:surround_insert_tail__old_val
	return ''
endfunction


function! SetSurroundTailToColon()
	call StoreOldSurroundTail()
	let g:surround_insert_tail = ': '
	return ''
endfunction

function! SetSurroundTailToSemicolon()
	call StoreOldSurroundTail()
	let g:surround_insert_tail = ';'
	return ''
endfunction

function! SetSurroundTailToComma()
	call StoreOldSurroundTail()
	let g:surround_insert_tail = ', '
	return ''
endfunction

function! SetSurroundTailToDot()
	call StoreOldSurroundTail()
	let g:surround_insert_tail = '.'
	return ''
endfunction


let g:is_auto_surround_input_enabled = 0


function! AutoSurroundInputEnable(silent)
	
	if g:is_auto_surround_input_enabled == 1
		
		if ! a:silent
			echo 'Auto surround input enabled already'
		endif
		
		return
	endif
	
	imap {\        <C-R>='{'<CR>
	imap }\        <C-R>='}'<CR>
	imap {         <C-G>s{
	imap }         <C-G>s}
	imap {<CR>     <C-G>S}
	imap {:        <C-R>=SetSurroundTailToColon()<CR><C-G>s{<C-R>=RestoreSurroundTail()<CR>
	imap }:        <C-R>=SetSurroundTailToColon()<CR><C-G>s}<C-R>=RestoreSurroundTail()<CR>
	imap {<CR>:    <C-R>=SetSurroundTailToColon()<CR><C-G>S}<C-R>=RestoreSurroundTail()<CR>
	imap {;        <C-R>=SetSurroundTailToSemicolon()<CR><C-G>s{<C-R>=RestoreSurroundTail()<CR>
	imap };        <C-R>=SetSurroundTailToSemicolon()<CR><C-G>s}<C-R>=RestoreSurroundTail()<CR>
	imap {<CR>;    <C-R>=SetSurroundTailToSemicolon()<CR><C-G>S}<C-R>=RestoreSurroundTail()<CR>
	imap {,        <C-R>=SetSurroundTailToComma()<CR><C-G>s{<C-R>=RestoreSurroundTail()<CR>
	imap },        <C-R>=SetSurroundTailToComma()<CR><C-G>s}<C-R>=RestoreSurroundTail()<CR>
	imap {<CR>,    <C-R>=SetSurroundTailToComma()<CR><C-G>S}<C-R>=RestoreSurroundTail()<CR>
	imap {.        <C-R>=SetSurroundTailToDot()<CR><C-G>s{<C-R>=RestoreSurroundTail()<CR>
	imap }.        <C-R>=SetSurroundTailToDot()<CR><C-G>s}<C-R>=RestoreSurroundTail()<CR>
	imap {<CR>.    <C-R>=SetSurroundTailToDot()<CR><C-G>S}<C-R>=RestoreSurroundTail()<CR>
	
	imap [\        <C-R>='['<CR>
	imap ]\        <C-R>=']'<CR>
	imap [         <C-G>s[
	imap ]         <C-G>s]
	imap [<CR>     <C-G>S]
	imap [:        <C-R>=SetSurroundTailToColon()<CR><C-G>s[<C-R>=RestoreSurroundTail()<CR>
	imap ]:        <C-R>=SetSurroundTailToColon()<CR><C-G>s]<C-R>=RestoreSurroundTail()<CR>
	imap [<CR>:    <C-R>=SetSurroundTailToColon()<CR><C-G>S]<C-R>=RestoreSurroundTail()<CR>
	imap [;        <C-R>=SetSurroundTailToSemicolon()<CR><C-G>s[<C-R>=RestoreSurroundTail()<CR>
	imap ];        <C-R>=SetSurroundTailToSemicolon()<CR><C-G>s]<C-R>=RestoreSurroundTail()<CR>
	imap [<CR>;    <C-R>=SetSurroundTailToSemicolon()<CR><C-G>S]<C-R>=RestoreSurroundTail()<CR>
	imap [,        <C-R>=SetSurroundTailToComma()<CR><C-G>s[<C-R>=RestoreSurroundTail()<CR>
	imap ],        <C-R>=SetSurroundTailToComma()<CR><C-G>s]<C-R>=RestoreSurroundTail()<CR>
	imap [<CR>,    <C-R>=SetSurroundTailToComma()<CR><C-G>S]<C-R>=RestoreSurroundTail()<CR>
	imap [.        <C-R>=SetSurroundTailToDot()<CR><C-G>s[<C-R>=RestoreSurroundTail()<CR>
	imap ].        <C-R>=SetSurroundTailToDot()<CR><C-G>s]<C-R>=RestoreSurroundTail()<CR>
	imap [<CR>.    <C-R>=SetSurroundTailToDot()<CR><C-G>S]<C-R>=RestoreSurroundTail()<CR>
	
	imap (\        <C-R>='('<CR>
	imap )\        <C-R>=')'<CR>
	imap (         <C-G>s(
	imap )         <C-G>s)
	imap (<CR>     <C-G>S)
	imap (:        <C-R>=SetSurroundTailToColon()<CR><C-G>s(<C-R>=RestoreSurroundTail()<CR>
	imap ):        <C-R>=SetSurroundTailToColon()<CR><C-G>s)<C-R>=RestoreSurroundTail()<CR>
	imap (<CR>:    <C-R>=SetSurroundTailToColon()<CR><C-G>S)<C-R>=RestoreSurroundTail()<CR>
	imap (;        <C-R>=SetSurroundTailToSemicolon()<CR><C-G>s(<C-R>=RestoreSurroundTail()<CR>
	imap );        <C-R>=SetSurroundTailToSemicolon()<CR><C-G>s)<C-R>=RestoreSurroundTail()<CR>
	imap (<CR>;    <C-R>=SetSurroundTailToSemicolon()<CR><C-G>S)<C-R>=RestoreSurroundTail()<CR>
	imap (,        <C-R>=SetSurroundTailToComma()<CR><C-G>s(<C-R>=RestoreSurroundTail()<CR>
	imap ),        <C-R>=SetSurroundTailToComma()<CR><C-G>s)<C-R>=RestoreSurroundTail()<CR>
	imap (<CR>,    <C-R>=SetSurroundTailToComma()<CR><C-G>S)<C-R>=RestoreSurroundTail()<CR>
	imap (.        <C-R>=SetSurroundTailToDot()<CR><C-G>s(<C-R>=RestoreSurroundTail()<CR>
	imap ).        <C-R>=SetSurroundTailToDot()<CR><C-G>s)<C-R>=RestoreSurroundTail()<CR>
	imap (<CR>.    <C-R>=SetSurroundTailToDot()<CR><C-G>S)<C-R>=RestoreSurroundTail()<CR>
	
	imap '\        <C-R>="'"<CR>
	imap "\        <C-R>='"'<CR>
	imap `\        <C-R>='`'<CR>
	imap '         <C-G>s'
	imap "         <C-G>s"
	imap `         <C-G>s`
	imap '<CR>     <C-G>S'
	imap "<CR>     <C-G>S"
	imap `<CR>     <C-G>S`
	imap ':        <C-R>=SetSurroundTailToColon()<CR><C-G>s'<C-R>=RestoreSurroundTail()<CR>
	imap ":        <C-R>=SetSurroundTailToColon()<CR><C-G>s"<C-R>=RestoreSurroundTail()<CR>
	imap `:        <C-R>=SetSurroundTailToColon()<CR><C-G>s`<C-R>=RestoreSurroundTail()<CR>
	imap '<CR>:    <C-R>=SetSurroundTailToColon()<CR><C-G>S'<C-R>=RestoreSurroundTail()<CR>
	imap "<CR>:    <C-R>=SetSurroundTailToColon()<CR><C-G>S"<C-R>=RestoreSurroundTail()<CR>
	imap `<CR>:    <C-R>=SetSurroundTailToColon()<CR><C-G>S`<C-R>=RestoreSurroundTail()<CR>
	imap ';        <C-R>=SetSurroundTailToSemicolon()<CR><C-G>s'<C-R>=RestoreSurroundTail()<CR>
	imap ";        <C-R>=SetSurroundTailToSemicolon()<CR><C-G>s"<C-R>=RestoreSurroundTail()<CR>
	imap `;        <C-R>=SetSurroundTailToSemicolon()<CR><C-G>s`<C-R>=RestoreSurroundTail()<CR>
	imap '<CR>;    <C-R>=SetSurroundTailToSemicolon()<CR><C-G>S'<C-R>=RestoreSurroundTail()<CR>
	imap "<CR>;    <C-R>=SetSurroundTailToSemicolon()<CR><C-G>S"<C-R>=RestoreSurroundTail()<CR>
	imap `<CR>;    <C-R>=SetSurroundTailToSemicolon()<CR><C-G>S`<C-R>=RestoreSurroundTail()<CR>
	imap ',        <C-R>=SetSurroundTailToComma()<CR><C-G>s'<C-R>=RestoreSurroundTail()<CR>
	imap ",        <C-R>=SetSurroundTailToComma()<CR><C-G>s"<C-R>=RestoreSurroundTail()<CR>
	imap `,        <C-R>=SetSurroundTailToComma()<CR><C-G>s`<C-R>=RestoreSurroundTail()<CR>
	imap '<CR>,    <C-R>=SetSurroundTailToComma()<CR><C-G>S'<C-R>=RestoreSurroundTail()<CR>
	imap "<CR>,    <C-R>=SetSurroundTailToComma()<CR><C-G>S"<C-R>=RestoreSurroundTail()<CR>
	imap `<CR>,    <C-R>=SetSurroundTailToComma()<CR><C-G>S`<C-R>=RestoreSurroundTail()<CR>
	imap '.        <C-R>=SetSurroundTailToDot()<CR><C-G>s'<C-R>=RestoreSurroundTail()<CR>
	imap ".        <C-R>=SetSurroundTailToDot()<CR><C-G>s"<C-R>=RestoreSurroundTail()<CR>
	imap `.        <C-R>=SetSurroundTailToDot()<CR><C-G>s`<C-R>=RestoreSurroundTail()<CR>
	imap '<CR>.    <C-R>=SetSurroundTailToDot()<CR><C-G>S'<C-R>=RestoreSurroundTail()<CR>
	imap "<CR>.    <C-R>=SetSurroundTailToDot()<CR><C-G>S"<C-R>=RestoreSurroundTail()<CR>
	imap `<CR>.    <C-R>=SetSurroundTailToDot()<CR><C-G>S`<C-R>=RestoreSurroundTail()<CR>
	
	let g:is_auto_surround_input_enabled = 1
	
	if ! a:silent
		echo 'Auto surround input enabled'
	endif
	
endfunction

function! AutoSurroundInputDisable(silent)
	
	if g:is_auto_surround_input_enabled == 0
		
		if ! a:silent
			echo 'Auto surround input disabled already'
		endif
		
		return
	endif
	
	iunmap {\
	iunmap }\
	iunmap {
	iunmap }
	iunmap {<CR>
	iunmap {:
	iunmap }:
	iunmap {<CR>:
	iunmap {;
	iunmap };
	iunmap {<CR>;
	iunmap {,
	iunmap },
	iunmap {<CR>,
	iunmap {.
	iunmap }.
	iunmap {<CR>.
	
	iunmap [\
	iunmap ]\
	iunmap [
	iunmap ]
	iunmap [<CR>
	iunmap [:
	iunmap ]:
	iunmap [<CR>:
	iunmap [;
	iunmap ];
	iunmap [<CR>;
	iunmap [,
	iunmap ],
	iunmap [<CR>,
	iunmap [.
	iunmap ].
	iunmap [<CR>.
	
	iunmap (\
	iunmap )\
	iunmap (
	iunmap )
	iunmap (<CR>
	iunmap (:
	iunmap ):
	iunmap (<CR>:
	iunmap (;
	iunmap );
	iunmap (<CR>;
	iunmap (,
	iunmap ),
	iunmap (<CR>,
	iunmap (.
	iunmap ).
	iunmap (<CR>.
	
	iunmap '\
	iunmap "\
	iunmap `\
	iunmap '
	iunmap "
	iunmap `
	iunmap '<CR>
	iunmap "<CR>
	iunmap `<CR>
	iunmap ':
	iunmap ":
	iunmap `:
	iunmap '<CR>:
	iunmap "<CR>:
	iunmap `<CR>:
	iunmap ';
	iunmap ";
	iunmap `;
	iunmap '<CR>;
	iunmap "<CR>;
	iunmap `<CR>;
	iunmap ',
	iunmap ",
	iunmap `,
	iunmap '<CR>,
	iunmap "<CR>,
	iunmap `<CR>,
	iunmap '.
	iunmap ".
	iunmap `.
	iunmap '<CR>.
	iunmap "<CR>.
	iunmap `<CR>.
	
	let g:is_auto_surround_input_enabled = 0
	
	if ! a:silent
		echo 'Auto surround input disabled'
	endif
	
endfunction

function! AutoSurroundInputToggle(silent)
	if g:is_auto_surround_input_enabled == 1
		call AutoSurroundInputDisable(a:silent)
	else
		call AutoSurroundInputEnable(a:silent)
	endif
endfunction

command! AutoSurroundInputEnable  call AutoSurroundInputEnable(0)
command! AutoSurroundInputDisable call AutoSurroundInputDisable(0)
command! AutoSurroundInputToggle  call AutoSurroundInputToggle(0)


"hack for wrap to <CR> with indentation

vmap S<CR> S<C-j>gvVkoj>

nmap ysiw<CR> ysiw<C-j>gvVkoj>
nmap ysaw<CR> ysaw<C-j>gvVkoj>
nmap ysiW<CR> ysiW<C-j>gvVkoj>
nmap ysaW<CR> ysaW<C-j>gvVkoj>

nmap ysi{<CR> ysi{<C-j>gvVkoj>
nmap ysa{<CR> ysa{<C-j>gvVkoj>
nmap ysi}<CR> ysi}<C-j>gvVkoj>
nmap ysa}<CR> ysa}<C-j>gvVkoj>

nmap ysi[<CR> ysi[<C-j>gvVkoj>
nmap ysa[<CR> ysa[<C-j>gvVkoj>
nmap ysi]<CR> ysi]<C-j>gvVkoj>
nmap ysa]<CR> ysa]<C-j>gvVkoj>

nmap ysi(<CR> ysi(<C-j>gvVkoj>
nmap ysa(<CR> ysa(<C-j>gvVkoj>
nmap ysi)<CR> ysi)<C-j>gvVkoj>
nmap ysa)<CR> ysa)<C-j>gvVkoj>

nmap ysi<<CR> ysi<<C-j>gvVkoj>
nmap ysa<<CR> ysa<<C-j>gvVkoj>
nmap ysi><CR> ysi><C-j>gvVkoj>
nmap ysa><CR> ysa><C-j>gvVkoj>

nmap ysi'<CR> ysi'<C-j>gvVkoj>
nmap ysa'<CR> ysa'<C-j>gvVkoj>
nmap ysi"<CR> ysi"<C-j>gvVkoj>
nmap ysa"<CR> ysa"<C-j>gvVkoj>
nmap ysi`<CR> ysi`<C-j>gvVkoj>
nmap ysa`<CR> ysa`<C-j>gvVkoj>

"vim: set noet :
