" additional commands
" Author: Viacheslav Lotsmanov
" License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE

" embedded terminal emulator split
com! TE  new | exe 'te' | star
com! VTE vne | exe 'te' | star

" tmux split (new pane in directory which is 'pwd' of current vim session).
" triggering '<cr>' asynchronously to force screen redraw after a split.
com! TS sil !tmux sp
com! TV sil !tmux sp -h
com! TW sil !tmux neww

com! MakeTags !ctags -R .

" Goyo and Limelight shorthands
com! -nargs=? -bar -bang -range LL
	\ cal limelight#execute(<bang>0, <count> > 0, <line1>, <line2>, <f-args>)
	\ | cal ColorschemeCustomizations()
com! -nargs=? -bar -bang GG
	\ cal goyo#execute(<bang>0, <q-args>)
	\ | cal ColorschemeCustomizations()

" Fold everything that matches a given regular expression
"
" Example (in Bash fold all empty lines and lines with only comments in them):
"   :cal FoldReg('\v^\s*(#|$)')
" Or in Vimscript
"   :cal FoldReg('\v^\s*("|$)')
function! g:FoldReg(rx) abort
	let b:freg = a:rx
	setlocal foldmethod=expr foldminlines=0
	let &l:foldexpr = 'getline(v:lnum) =~# b:freg ? 1 : 0'
	normal! zM
endfunction

" Example (in Bash fold all empty lines and lines with only comments in them):
"   :FoldReg \v^\s*(#|$)
"   :FoldRegRaw '\v^\s*(#|$)'
" Or in Vimscript
"   :FoldReg \v^\s*("|$)
"   :FoldRegRaw '\v^\s*("|$)'
let b:freg='' | setl fdm=expr fml=0 | let &l:fde='getline(v:lnum)=~#b:freg?1:0' | norm! zM
command! -nargs=+ FoldReg call g:FoldReg(<q-args>)
command! -nargs=1 FoldRegRaw call g:FoldReg(<args>)

" vim: set noet :
