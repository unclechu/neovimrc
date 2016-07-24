"set listchars
"Author: Viacheslav Lotsmanov

if has("gui_running")
	set listchars=tab:>-,trail:·,eol:¶,nbsp:⎵
else
	set listchars=tab:‣ ,trail:·,eol: ,nbsp:⎵
endif

set list

"vim: set noet :
