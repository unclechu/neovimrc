"GUI configs
"Author: Viacheslav Lotsmanov

if has("gui_running")
	
	set guioptions-=T "hide toolbar
	set guioptions-=m "hide menu
	
	"hide scrollbar
	set guioptions-=r
	set guioptions-=R
	set guioptions-=l
	set guioptions-=L
	
	"maximize gvim window
	"set lines=999 columns=999
	set lines=50 columns=100
endif

"vim: set noet :
