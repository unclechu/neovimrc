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

" vim: set noet :
