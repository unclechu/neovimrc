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

nmap ysI{<CR> cs{}ysi{<CR>
nmap ysA{<CR> cs{}ysa{<CR>
nmap ysI}<CR> cs{}ysi}<CR>
nmap ysA}<CR> cs{}ysa}<CR>

nmap ysi[<CR> ysi[<C-j>gvVkoj>
nmap ysa[<CR> ysa[<C-j>gvVkoj>
nmap ysi]<CR> ysi]<C-j>gvVkoj>
nmap ysa]<CR> ysa]<C-j>gvVkoj>

nmap ysI[<CR> cs[]ysi[<CR>
nmap ysA[<CR> cs[]ysa[<CR>
nmap ysI]<CR> cs[]ysi]<CR>
nmap ysA]<CR> cs[]ysa]<CR>

nmap ysi(<CR> ysi(<C-j>gvVkoj>
nmap ysa(<CR> ysa(<C-j>gvVkoj>
nmap ysi)<CR> ysi)<C-j>gvVkoj>
nmap ysa)<CR> ysa)<C-j>gvVkoj>

nmap ysI(<CR> cs()ysi(<CR>
nmap ysA(<CR> cs()ysa(<CR>
nmap ysI)<CR> cs()ysi)<CR>
nmap ysA)<CR> cs()ysa)<CR>

nmap ysi<<CR> ysi<<C-j>gvVkoj>
nmap ysa<<CR> ysa<<C-j>gvVkoj>
nmap ysi><CR> ysi><C-j>gvVkoj>
nmap ysa><CR> ysa><C-j>gvVkoj>

nmap ysI<<CR> cs<>ysi<<CR>
nmap ysA<<CR> cs<>ysa<<CR>
nmap ysI><CR> cs<>ysi><CR>
nmap ysA><CR> cs<>ysa><CR>

nmap ysi'<CR> ysi'<C-j>gvVkoj>
nmap ysa'<CR> ysa'<C-j>gvVkoj>
nmap ysi"<CR> ysi"<C-j>gvVkoj>
nmap ysa"<CR> ysa"<C-j>gvVkoj>
nmap ysi`<CR> ysi`<C-j>gvVkoj>
nmap ysa`<CR> ysa`<C-j>gvVkoj>

" Using a trick to temporarily change quotations to parenthesis
" to trim spacing characters
nmap ysI'<CR> cs'(cs('ysi'<CR>
nmap ysA'<CR> cs'(cs('ysa'<CR>
nmap ysI"<CR> cs"(cs("ysi"<CR>
nmap ysA"<CR> cs"(cs("ysa"<CR>
nmap ysI`<CR> cs`(cs(`ysi`<CR>
nmap ysA`<CR> cs`(cs(`ysa`<CR>


" vim: set noet :
