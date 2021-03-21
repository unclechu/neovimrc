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

" vim: set noet :
