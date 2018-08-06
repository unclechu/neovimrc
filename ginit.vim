" Author: Viacheslav Lotsmanov


" applying local additional config
let g:local_guirc_pre = $HOME . '/.neovimrc-gui-local-pre'
if filereadable(g:local_guirc_pre) | exec 'so ' . g:local_guirc_pre | endif


" because default map doesn't work in nvim-qt
nnoremap <C-Space> :CtrlSpace<CR>

if !exists('s:is_neovim_gtk_gui')
	let s:is_neovim_gtk_gui = exists('g:GtkGuiLoaded') ? 1 : 0
en

" works for neovim-gtk and for neovim-qt since a250faf from 25-07-2018.
" earlier neovim-qt have been supposed to be run with --no-ext-tabline option.
call rpcnotify((s:is_neovim_gtk_gui ? 1 : 0), 'Gui', 'Option', 'Tabline', 0)

let s:font_family = 'Fira Code'
let s:font_size = 9

function! s:update_font()
	if s:is_neovim_gtk_gui " neovim-gtk
		call rpcnotify(
			\ 1, 'Gui', 'Font', s:font_family.' '.string(s:font_size))
	el " neovim-qt
		call rpcnotify(
			\ 0, 'Gui', 'Font', s:font_family.':h'.string(s:font_size))
	en
endfunction

function! s:set_font_family(family)
	let s:font_family = a:family
	call s:update_font()
endfunction

command! -nargs=1 GuiFontFamily call <SID>set_font_family(<args>)

" fast font inc/dec

call s:update_font()

function! s:font_size_dec(count)
	let l:count = a:count | if l:count < 1 | let l:count = 1 | endif
	let s:font_size = s:font_size - l:count
	if s:font_size < 1 | let s:font_size = 1 | endif
	call s:update_font()
endfunction

function! s:font_size_inc(count)
	let l:count = a:count | if l:count < 1 | let l:count = 1 | endif
	let s:font_size = s:font_size + l:count
	if s:font_size < 1 | let s:font_size = 1 | endif
	call s:update_font()
endfunction

command! GuiFontSizeDec call <SID>font_size_dec(1)
command! GuiFontSizeInc call <SID>font_size_inc(1)
command! -nargs=1 GuiFontSizeDecN call <SID>font_size_dec(<args>)
command! -nargs=1 GuiFontSizeIncN call <SID>font_size_inc(<args>)

nnoremap <leader>- :<C-u>call <SID>font_size_dec(v:count)<CR>
nnoremap <leader>+ :<C-u>call <SID>font_size_inc(v:count)<CR>
nnoremap <leader>= :<C-u>call <SID>font_size_inc(v:count)<CR>

nnoremap <C-ScrollWheelUp>   :call <SID>font_size_inc(1)<CR>
nnoremap <C-ScrollWheelDown> :call <SID>font_size_dec(1)<CR>


" applying local additional config
let g:local_guirc_post = $HOME . '/.neovimrc-gui-local-post'
if filereadable(g:local_guirc_post) | exec 'so ' . g:local_guirc_post | endif
