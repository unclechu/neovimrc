" vim-javascript plugin configs
" Author: Viacheslav Lotsmanov

if !exists('s:loaded')
	" conceals is disabled
	" autocmd FileType javascript setlocal conceallevel=1
	let s:loaded = 1
endif

let g:javascript_conceal_function   = "ƒ"
let g:javascript_conceal_null       = "ø"
let g:javascript_conceal_this       = "☦"
let g:javascript_conceal_return     = "⇐"
let g:javascript_conceal_undefined  = "¿"
let g:javascript_conceal_prototype  = "∷"

let g:javascript_plugin_flow = 1

" vim: set noet :
