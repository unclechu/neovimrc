" additional surround bindings
" Author: Viacheslav Lotsmanov
" License: MIT https://raw.githubusercontent.com/unclechu/neovimrc/master/LICENSE


" hack for wrap to <CR> with indentation

xmap S<CR> S<C-j>gvVkoj>

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


" vim: set noet :
