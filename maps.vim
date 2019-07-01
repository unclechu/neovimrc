" custom maps
" Author: Viacheslav Lotsmanov

let mapleader = ','

" flying between buffers
" (c) https://bairuidahu.deviantart.com/art/Flying-vs-Cycling-261641977
nnoremap <leader>bl :ls<CR>:b<space>
nnoremap <leader>bd :ls<CR>:bd<space>
nnoremap <leader>bD :ls<CR>:bd!<space>
nnoremap <leader>bp :b#<CR>
nnoremap <leader>bo :bro o<cr>
nnoremap <leader><space> :ls<cr>
nnoremap <space><leader> :o<cr>

nnoremap <leader>r :let @/ = ''<CR>:ec 'Reset search'<CR>

" 'cr' means 'config reload'
nnoremap <leader>cr :source $MYVIMRC<CR>

" nnoremap <leader>n :NERDTreeMirrorToggle<CR>
nnoremap <leader>n  :NERDTreeToggle<CR>
nnoremap <leader>N  :NERDTreeToggle<CR><C-w>p
nnoremap <leader>fn :NERDTreeFind<CR>
nnoremap <leader>fo :NERDTreeFind<CR><C-w>p
nnoremap <leader>fb :NERDTreeFind<CR><C-w>p:TagbarOpen<CR>
nnoremap <leader>t  :TagbarToggle<CR>
nnoremap <leader>u  :GundoToggle<CR>
nnoremap <leader>'  :call LanguageClient_contextMenu()<CR>

xmap <Enter> <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" UltiSnips map without conflicts
" with own <Tab> maps for visual and select modes.
if has('python3') || has('python')
	" FIXME for js/ts snippets UltiSnips#SnippetsInCurrentScope() returns empty
	"       dictionary if a snippet doesn't have space character before while
	"       UltiSnips#ExpandSnippet() correctly expands such a snippet
	function! s:IsSnippetExpandable()
		return !(
			\ col('.') <= 1
			\ || !empty(matchstr(getline('.'), '\%' . (col('.') - 1) . 'c\s'))
			\ || empty(UltiSnips#SnippetsInCurrentScope())
			\ )
	endfunction

	inoremap <expr> <Tab> <SID>IsSnippetExpandable()
		\ ? '<C-R>=UltiSnips#ExpandSnippet()<CR>' : '<Tab>'

	" FIXME fix the issue with UltiSnips#SnippetsInCurrentScope() and you wont
	"       need this hack to force expanding anymore
	inoremap <C-x><Tab> <C-R>=UltiSnips#ExpandSnippet()<CR>
endif

com! FZFGit call fzf#run({
	\ 'source': 'git ls-files',
	\ 'sink': 'e',
	\ 'down': '40%',
	\ 'options': '--color=' . (&bg == 'light' ? 'light' : 'dark'),
	\})

com! FZFMy call fzf#run({
	\ 'sink': 'e',
	\ 'down': '40%',
	\ 'options': '--color=' . (&bg == 'light' ? 'light' : 'dark'),
	\})

function! g:FuzzyGitFileMaps()
	nnoremap <A-p> :tabnew<CR>:FZFGit<CR>
	nnoremap <C-p> :FZFGit<CR>
endfunction

" fuzzy search for a file
nnoremap <A-p> :tabnew<CR>:FZFMy<CR>
nnoremap <C-p> :FZFMy<CR>

" prevent triggering `s` when `<leader>s` is pressed
" but next symbol not in time.
" can't use `<Nop>` because it affects pressing this second time,
" maybe it's some bug of neovim or something, when i press `<leader>s` wait some
" time and again `<leader>s` then `s` is triggered, strange. that's why it
" solved by these hacks.
nnoremap <leader>s  <Esc>
nnoremap <leader>sw <Esc>
xnoremap <leader>s  <C-g><C-g>
xnoremap <leader>sw <C-g><C-g>

" GitGutter keys
no <leader>gg :GitGutterAll<CR>
nnoremap <leader>gv :GitGutterPreviewHunk<CR>
nnoremap <Leader>ga :GitGutterStageHunk<CR>
nnoremap <Leader>gr :GitGutterUndoHunk<CR>
nmap ]c <Plug>GitGutterNextHunk
nmap [c <Plug>GitGutterPrevHunk

" git status in new tab
nnoremap <leader>gs :tabnew %<CR>:Gstatus<CR><C-w>o
nnoremap <leader>gS :Gstatus<CR><C-w>o

" modes togglers
nnoremap <leader>mw :WrapToggle<CR>
nnoremap <leader>mp :PasteToggle<CR>
nnoremap <leader>ml :ListToggle<CR>
nnoremap <leader>mn :RelativeNumberToggle<CR>
nnoremap <leader>m] :DelimitMateSwitch<CR>
nnoremap <leader>mg :GitGutterToggle<CR>
nnoremap <leader>mc :AutoClearSpacesAtEOFToggle<CR>
nnoremap <leader>mt :AutoTrimSpacesAtEOFToggle<CR>

" some buffer configs
nnoremap <leader>ft :set filetype=
nnoremap <leader>fl :set foldlevel=
nnoremap <leader>fm :set foldmethod=

" some windows things
nnoremap <leader>sww :9999wincmd < \| set winwidth=
nnoremap <leader>swh :9999wincmd - \| set winheight=
nnoremap <leader>swW :set wfw \| 9999wincmd < \| set winwidth=
nnoremap <leader>swH :set wfh \| 9999wincmd - \| set winheight=


" Syntastic
" nnoremap <leader>si :SyntasticInfo<CR>
" nnoremap <leader>sc :SyntasticCheck<CR>
" nnoremap <leader>sr :SyntasticReset<CR>

" Neomake
nnoremap <leader>si :NeomakeInfo<CR>
nnoremap <leader>sc :Neomake<CR>
" nnoremap <leader>sr :<CR>


" show hint
nnoremap <leader>sh :ShowHint<CR>

" short EasyAlign aliases
xnoremap <leader>:  :EasyAlign/:/<CR>
xnoremap <leader>g: :EasyAlign : { 'lm': 0, 'stl': 0 }<CR>
" haskell record syntax (align by '=' inside braces)
xnoremap <leader>=  :EasyAlign/\({.*\\|,.*\)\@<==/<CR>
" haskell alone '='
xnoremap <space>=   :EasyAlign/ = /{'lm':0,'rm':0}<CR>
nnoremap <leader>a  :EasyAlign
xnoremap <leader>a  :EasyAlign
xnoremap <leader>A  :EasyAlign/  /{'lm':0,'rm':0}
	\<left><left><left><left><left><left><left><left><left>
	\<left><left><left><left><left><left><left><left>

" CtrlSF bindings
nmap     <leader>sf <Plug>CtrlSFPrompt
xmap     <leader>sf <Plug>CtrlSFVwordPath
xmap     <leader>sF <Plug>CtrlSFVwordExec
nmap     <leader>sn <Plug>CtrlSFCwordPath
nmap     <leader>sN <Plug>CtrlSFCwordExec
nmap     <leader>sp <Plug>CtrlSFPwordPath
nmap     <leader>sP <Plug>CtrlSFPwordExec
nnoremap <leader>so :CtrlSFOpen<CR>
nnoremap <leader>st :CtrlSFToggle<CR>

" doesn't work with visual-block selection
fu! s:get_selected_text()
	let [l:line_a, l:col_a] = getpos("'<")[1:2]
	let [l:line_b, l:col_b] = getpos("'>")[1:2]
	let l:lines = getline(l:line_a, l:line_b)
	if len(l:lines) == 0 | retu '' | el
		let l:lines[-1] = l:lines[-1][: l:col_b - 1  ]
		let l:lines[ 0] = l:lines[ 0][  l:col_a - 1 :]
		retu join(l:lines, "\n")
	en
endf

" escape quotes to put them inside double single quotes '...'
fu! s:escq(x)
	retu substitute(
		\substitute(
		\substitute(
		\ a:x, '''', '&&', 'g'),
		\ '\"', '\\&', 'g'),
		\ '|', ("'.'".'\\|'."'.'"), 'g')
endf

" git-grep shortcuts
" (kinda like CtrlSF maps but with 'g' instead of 's')
nn <leader>gf :exe'TE'\|put='git grep -nF -- '.shellescape('').
	\' \\| git-grep-nvr.sh<C-v><CR>'
	\<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
	\<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
	\<Left><Left><Left><Left><Left>
xn <leader>gf <Esc>:exe'TE'\|put='git grep -nF -- '.
	\shellescape('<C-r>=<SID>escq(<SID>get_selected_text())<CR>').
	\' \\| git-grep-nvr.sh<C-v><CR>'
	\<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
	\<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
	\<Left><Left><Left><Left><Left>
xm <leader>gF <leader>gf<CR>
no <leader>gn :exe'TE'\|put='git grep -nF -- '.
	\shellescape('<C-r>=<SID>escq(expand('<cword>'))<CR>').
	\' \\| git-grep-nvr.sh<C-v><CR>'
	\<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
	\<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
	\<Left><Left><Left><Left><Left>
nm <leader>gN <leader>gn<CR>
nn <leader>gp :exe'TE'\|put='git grep -nF -- '.
	\shellescape('<C-r>=<SID>escq(@/)<CR>').
	\' \\| git-grep-nvr.sh<C-v><CR>'
	\<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
	\<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
	\<Left><Left><Left><Left><Left>
nm <leader>gP <leader>gp<CR>

" CtrlSpace panel open
nnoremap <C-Space> :CtrlSpace<CR>

" Make Hoogle search easier (because I use it very often)
nnoremap <A-g> :Hoogle<space>
xnoremap <A-g> <Esc>:Hoogle <C-r>=<SID>escq(<SID>get_selected_text())<CR><CR>


" EasyMotion bindings (<Space> for overwin-mode, <Leader> for current window)

"  L----  ('L' - with <leader> or ' ' - without it)
" QWerty  (uppercase means it have map)
" SS----  ('S' - overwin with <space>)

" move anywhere ('q' means 'quick (move)')
nmap q         <Plug>(easymotion-bd-w)
xmap q         <Plug>(easymotion-bd-w)
nmap <Space>q  <Plug>(easymotion-overwin-w)
" doesn't make sense with 'overwin' mode
xmap <Space>q  <Nop>
" some plugins uses 'q' map to close window.
" by using 'g' prefix we still able to call easymotion.
nmap gq        <Plug>(easymotion-bd-w)
xmap gq        <Plug>(easymotion-bd-w)

" move to place with specific symbols
nmap <leader>w <Plug>(easymotion-bd-f2)
xmap <leader>w <Plug>(easymotion-bd-f2)
nmap <Space>w  <Plug>(easymotion-overwin-f2)
" doesn't make sense with 'overwin' mode
xmap <Space>w  <Nop>

" just another hook as `<leader>e` but for single symbol
nmap <leader>e <Plug>(easymotion-bd-f)
xmap <leader>e <Plug>(easymotion-bd-f)
nmap <Space>e  <Plug>(easymotion-overwin-f)
" doesn't make sense with 'overwin' mode
xmap <Space>e  <Nop>

" LL-L  ('L' - with <leader> or ' ' - without it)
" ZXcV  (uppercase means it have map)
" -S--  ('S' - overwin with <space>)

" move over the line
nmap <leader>z <Plug>(easymotion-lineanywhere)
xmap <leader>z <Plug>(easymotion-lineanywhere)

" move between lines
" (also between empty lines with indentation)
nmap <leader>x <Plug>(easymotion-bd-jk)
xmap <leader>x <Plug>(easymotion-bd-jk)
nmap <Space>x  <Plug>(easymotion-overwin-line)
xmap <Space>x  <Nop>

" turn on visual mode and select to specific place
nmap <leader>v v<Plug>(easymotion-bd-w)
nmap <leader>V V<Plug>(easymotion-bd-jk)

" move by direction
nmap <leader>l <Plug>(easymotion-lineforward)
xmap <leader>l <Plug>(easymotion-lineforward)
nmap <leader>h <Plug>(easymotion-linebackward)
xmap <leader>h <Plug>(easymotion-linebackward)
nmap <leader>j <Plug>(easymotion-j)
xmap <leader>j <Plug>(easymotion-j)
nmap <leader>k <Plug>(easymotion-k)
xmap <leader>k <Plug>(easymotion-k)


" quickhl
nmap <Space>m <Plug>(quickhl-manual-this)
xmap <Space>m <Plug>(quickhl-manual-this)
nmap <Space>M <Plug>(quickhl-manual-reset)
xmap <Space>M <Plug>(quickhl-manual-reset)
nmap <Space>n <Plug>(quickhl-cword-toggle)


" remove word selection symbols after paste from search
nmap <leader>c/  ds\ds>
" plugs to prevent mess about triggering default 'p' or 'P'
map  <leader>p   <Nop>
map  <leader>P   <Nop>
" paste searched word and clean it
map  <leader>p/  '/phds\ds>
map  <leader>P/  '/Phds\ds>
nmap <leader>po  <A-.>jP
nmap <leader>pO  <A-,>kP

" another alias to system X clipboard
noremap '<Space> "+
noremap <Space>' "*
" another alias to 'last yank' register
noremap <A-y> "0

fu! s:copy_many_lines_as_one(sys_clipboard)
	let l:view = winsaveview() | let l:buf = a:sys_clipboard ? '"+' : ''
	exec 'norm! gvJgv'.l:buf.'yu'
	cal winrestview(l:view)
endf

" copy multiple selected lines as one single line
xn <leader>y <Esc>:cal <SID>copy_many_lines_as_one(0)<CR>
" copy multiple selected lines as one single line to system clipboard
xn <leader>Y <Esc>:cal <SID>copy_many_lines_as_one(1)<CR>


" forward version of <C-h>
no! <C-l> <Del>


" colorscheme stuff
noremap <leader>ss <Esc>:set background=
noremap <leader>sb :BackgroundToggle<CR>
noremap <leader>sB :GruvboxContrastRotate<CR>

nnoremap gy Y:let @0 = substitute(@0, '.', ' ', 'g')<CR>:ec<CR>
nnoremap gY Y:let @0 = substitute(@0, '[^\r\n\t]', ' ', 'g')<CR>:ec<CR>
xnoremap gy y:let @0 = substitute(@0, '.', ' ', 'g')<CR>:ec<CR>
xnoremap gY y:let @0 = substitute(@0, '[^\r\n\t]', ' ', 'g')<CR>:ec<CR>

" walking between windows (hjkl)
nnoremap <C-h>     :wincmd h<CR>
xnoremap <C-h>     <Esc>:wincmd h<CR>
nnoremap <C-j>     :wincmd j<CR>
xnoremap <C-j>     <Esc>:wincmd j<CR>
nnoremap <C-k>     :wincmd k<CR>
xnoremap <C-k>     <Esc>:wincmd k<CR>
nnoremap <C-l>     :wincmd l<CR>
xnoremap <C-l>     <Esc>:wincmd l<CR>
" walking between windows (arrow keys)
nnoremap <C-Left>  :wincmd h<CR>
xnoremap <C-Left>  <Esc>:wincmd h<CR>
nnoremap <C-Right> :wincmd l<CR>
xnoremap <C-Right> <Esc>:wincmd l<CR>
nnoremap <C-Up>    :wincmd k<CR>
xnoremap <C-Up>    <Esc>:wincmd k<CR>
nnoremap <C-Down>  :wincmd j<CR>
xnoremap <C-Down>  <Esc>:wincmd j<CR>
" windows size minimization/maximization/normalization
nnoremap <A-=>     :wincmd =<CR>
nnoremap <A-->     :wincmd _<CR>
nnoremap <A-\>     :wincmd \|<CR>

" walk between windows by alt+arrow keys
nnoremap <A-Left>  zh
xnoremap <A-Left>  zh
nnoremap <A-Right> zl
xnoremap <A-Right> zl
nnoremap <A-Up>    <C-y>
xnoremap <A-Up>    <C-y>
nnoremap <A-Down>  <C-e>
xnoremap <A-Down>  <C-e>

" resizing windows by alt+shift+arrow keys
nnoremap <A-S-Left>  :wincmd <<CR>
xnoremap <A-S-Left>  <Esc>:wincmd <<CR>
nnoremap <A-S-Right> :wincmd ><CR>
xnoremap <A-S-Right> <Esc>:wincmd ><CR>
nnoremap <A-S-Up>    :wincmd +<CR>
xnoremap <A-S-Up>    <Esc>:wincmd +<CR>
nnoremap <A-S-Down>  :wincmd -<CR>
xnoremap <A-S-Down>  <Esc>:wincmd -<CR>

" zoom buffer hack ('fz' means 'full size')
nnoremap <leader>fz :999wincmd ><CR>:999wincmd +<CR>
xnoremap <leader>fz <Esc>:999wincmd ><CR>:999wincmd +<CR>gv

" moving between history in command mode
cno <C-p> <Up>
cno <C-n> <Down>

" moving tabs
nnoremap <C-S-PageUp>   :tabm-1<CR>
nnoremap <C-S-PageDown> :tabm+1<CR>

" jump by half of screen by pageup/pagedown
nmap <PageUp>     <C-u>
nmap <PageDown>   <C-d>
xmap <PageUp>     <C-u>
xmap <PageDown>   <C-d>
" default jump by pageup/pagedown with shift prefix
nmap <S-PageUp>   <C-b>
nmap <S-PageDown> <C-f>
xmap <S-PageUp>   <C-b>
xmap <S-PageDown> <C-f>

nmap g/        <Plug>(incsearch-easymotion-/)
nmap g?        <Plug>(incsearch-easymotion-?)
nmap <leader>/ <Plug>(incsearch-easymotion-stay)

" get rid off randomly turning ex-mode on
nm Q     <Nop>
nm gQ    <Nop>
nm <A-Q> <Nop>

" remap macros key under leader
" default 'q' remapped to easymotion call
noremap <leader>q q

xnoremap <Tab> <Esc>
snoremap <Tab> <Esc>
tnoremap <Leader><Tab> <C-\><C-n>
tnoremap <Leader><Esc> <C-\><C-n>

" thanks to Minoru for the advice
noremap ; :
" noremap : ;

" thanks to r3lgar for the advice (swap default <leader> and comma)
noremap \ ;
noremap \| ,

" because working with clipboard registers is more important
noremap ' "
noremap " '
noremap "" ''
nnoremap '' :reg<CR>

" custom behavior of big R in visual mode
xnoremap R r<Space>R

" break line but keep same column position for rest of the line
fu! s:split_next_line(new_col_offset, stay)
	let l:pos=getcurpos() | let l:line=getline('.') | let l:vc=virtcol('$')
	if l:pos[4] >= l:vc
		pu=repeat(' ', l:pos[4] - 1 + a:new_col_offset)
		cal setline(l:pos[1], l:line[:l:pos[2]])
	el
		pu=repeat(' ', l:pos[4] - 1 + a:new_col_offset) . l:line[l:pos[2] - 1:]
		cal setline(l:pos[1], l:line[:l:pos[2] - 2])
	en
	if a:stay
		cal setpos('.', l:pos)
	elsei l:pos[4] >= l:vc
		let l:pos[1] += 1 | let l:pos[2] = l:pos[4] + a:new_col_offset
		let l:pos[3] = 0 | unlet l:pos[4] | cal setpos('.', l:pos)
	en
endf
inoremap <A-CR> <C-o>:call <SID>split_next_line( 0, 0)<CR>
" cannot map <S-CR> to make <A-S-CR> alternative
" imap <A-S-CR> <C-o>:call <SID>split_next_line(-1, 0)<CR>
inoremap <A-'>  <C-o>:call <SID>split_next_line( 0, 1)<CR>
inoremap <A-">  <C-o>:call <SID>split_next_line(-1, 1)<CR>
fu! s:split_prev_line(new_col_offset, stay)
	let l:pos=getcurpos() | let l:line=getline('.') | let l:vc=virtcol('$')
	if l:pos[4] >= l:vc
		pu!=repeat(' ', l:pos[4] - 1 + a:new_col_offset)
		cal setline(l:pos[1] + 1, l:line[:l:pos[2]])
	el
		pu!=repeat(' ', l:pos[4] - 1 + a:new_col_offset) . l:line[l:pos[2] - 1:]
		cal setline(l:pos[1] + 1, l:line[:l:pos[2] - 2])
	en
	if a:stay
		let l:pos[1] += 1 | cal setpos('.', l:pos)
	elsei l:pos[4] >= l:vc
		let l:pos[2] = l:pos[4] + a:new_col_offset | let l:pos[3] = 0
		unlet l:pos[4] | cal setpos('.', l:pos)
	en
endf
inoremap <A-\>  <C-o>:call <SID>split_prev_line( 0, 0)<CR>
inoremap <A-\|> <C-o>:call <SID>split_prev_line(-1, 0)<CR>
inoremap <A-]>  <C-o>:call <SID>split_prev_line( 0, 1)<CR>
inoremap <A-}>  <C-o>:call <SID>split_prev_line(-1, 1)<CR>

fu! s:new_line_after()
	let l:x = getpos('.') | pu ='' | cal setpos('.', l:x)
endf
nnoremap <A-.> :cal <SID>new_line_after()<CR>
fu! s:new_line_before()
	let l:x = getpos('.') | pu! ='' | let l:x[1] += 1 | cal setpos('.', l:x)
endf
nnoremap <A-,> :cal <SID>new_line_before()<CR>
nmap <leader>o <A-.>ji
nmap <leader>O <A-,>ki

imap <A-Space> <Space><Left>


" custom numbers line keys

nnoremap ! #:ShowSearchIndex<CR>
nnoremap g! :let @/='\V\<'.expand('<cword>').'\>'<CR>:ShowSearchIndex<CR>
xnoremap ! :<C-u>call VisualStarSearchSet('?')<CR>?<C-R>=@/<CR><CR>:ShowSearchIndex<CR>
xnoremap g! :<C-u>call VisualStarSearchSet('?')<CR>:ShowSearchIndex<CR>
nnoremap @ *:ShowSearchIndex<CR>
nnoremap g@ :let @/='\V\<'.expand('<cword>').'\>'<CR>:ShowSearchIndex<CR>
xnoremap @ :<C-u>call VisualStarSearchSet('/')<CR>/<C-R>=@/<CR><CR>:ShowSearchIndex<CR>
xnoremap g@ :<C-u>call VisualStarSearchSet('/')<CR>:ShowSearchIndex<CR>
" noremap ! #
" noremap @ *

" begin/end of line ignoring indentation and trailing whitespaces
noremap # ^
noremap g# g^
noremap $ g_
noremap g$ g$

" default behavior of %
" noremap %

" noremap ^ 0
" we already have 0, I never use this key (^) this way
" let's remap it to '|' that in case was remapped too
noremap ^ \|
noremap g^ g0

" opposite to 0
noremap & $
noremap g& g$

" macros call
noremap * @
noremap g* g@

" swapping j/k with gj/gk
nnoremap j gj
xnoremap j gj
nnoremap k gk
xnoremap k gk
nnoremap gj j
xnoremap gj j
nnoremap gk k
xnoremap gk k

" relative tabnext by default
nnoremap gt :<C-u>exec join(repeat(['tabnext'], v:count1), '\|')<CR>
xnoremap gt :<C-u>exec join(repeat(['tabnext'], v:count1), '\|')<CR>
nnoremap ,gt gt
xnoremap ,gt gt

" additional move over cursor history (as alternative to ^O/^I).
" moving over changelist (see :changes).
nnoremap <A-o> g;
nnoremap <A-i> g,

" navigating by tabs
nmap <A-f> gt
nmap <A-b> gT
nmap <A-1> 1,gt
nmap <A-2> 2,gt
nmap <A-3> 3,gt
nmap <A-4> 4,gt
nmap <A-5> 5,gt
nmap <A-6> 6,gt
nmap <A-7> 7,gt
nmap <A-8> 8,gt
nmap <A-9> 9,gt
nmap <A-0> 10,gt

" default maps disabled for plugin
cno <expr> <CR> '<CR>' . (getcmdtype() =~ '[/?]' ? ':ShowSearchIndex<CR>' : '')
nnoremap n n:ShowSearchIndex<CR>
nnoremap N N:ShowSearchIndex<CR>

nnoremap <A-t> :tabnew<CR>
nnoremap <A-w> :tabclose<CR>

" quick hook for 'IndentText'
xnoremap <A-i> ym0gvc<Esc>`0:call<space>IndentText()<CR>
xnoremap <A-S-i> ym0gvI<Esc>`0:call<space>IndentText()<CR>

" pasting from default buffer in insert/cmdline mode
no! <A-p> <C-r>"
no! <A-y> <C-r>0

" to create short aliases for tTfF jumps to unicode symbols
function! s:UnicodeJumpsShortcuts(ascii, uni)
	for mpfx in ['n', 'x']
		for apfx in ['', 'd', 'c']
			exec l:mpfx.'no '.l:apfx.'t<A-'.a:ascii.'> '.l:apfx.'t'.a:uni
			exec l:mpfx.'no '.l:apfx.'T<A-'.a:ascii.'> '.l:apfx.'T'.a:uni
			exec l:mpfx.'no '.l:apfx.'f<A-'.a:ascii.'> '.l:apfx.'f'.a:uni
			exec l:mpfx.'no '.l:apfx.'F<A-'.a:ascii.'> '.l:apfx.'F'.a:uni
		endfor
	endfor
endfunction

" based on snippets for Haskell
call s:UnicodeJumpsShortcuts(';', '∷')
call s:UnicodeJumpsShortcuts(':', '∷')
call s:UnicodeJumpsShortcuts('<', '←')
call s:UnicodeJumpsShortcuts('>', '→')
call s:UnicodeJumpsShortcuts('[', '⇐')
call s:UnicodeJumpsShortcuts(']', '⇒')
call s:UnicodeJumpsShortcuts('.', '∘')
call s:UnicodeJumpsShortcuts(',', '•')
call s:UnicodeJumpsShortcuts('A', '∀')
call s:UnicodeJumpsShortcuts('a', '∧') " 'a' for 'and'
call s:UnicodeJumpsShortcuts('o', '∨') " 'o' for 'or'
call s:UnicodeJumpsShortcuts('=', '≡')
call s:UnicodeJumpsShortcuts('-', '≠')
call s:UnicodeJumpsShortcuts('_', '≢')
call s:UnicodeJumpsShortcuts('l', '≤') " 'l' for 'less'
call s:UnicodeJumpsShortcuts('g', '≥') " 'g' for 'greater'
call s:UnicodeJumpsShortcuts('+', '⧺')
call s:UnicodeJumpsShortcuts('*', '⋅')
call s:UnicodeJumpsShortcuts('x', '×')
call s:UnicodeJumpsShortcuts('/', '÷')
call s:UnicodeJumpsShortcuts('e', '∈')
call s:UnicodeJumpsShortcuts('E', '∉')
call s:UnicodeJumpsShortcuts('3', '∋')
call s:UnicodeJumpsShortcuts('#', '∌')
call s:UnicodeJumpsShortcuts('Z', 'ℤ')
call s:UnicodeJumpsShortcuts('N', 'ℕ')
call s:UnicodeJumpsShortcuts('Q', 'ℚ')
call s:UnicodeJumpsShortcuts('R', 'ℝ')
call s:UnicodeJumpsShortcuts('B', '𝔹')
call s:UnicodeJumpsShortcuts('P', 'π')
call s:UnicodeJumpsShortcuts('8', '∞')
call s:UnicodeJumpsShortcuts('d', '…') " 'd' for 'dots'
call s:UnicodeJumpsShortcuts('{', '«')
call s:UnicodeJumpsShortcuts('}', '»')
call s:UnicodeJumpsShortcuts('v', '⋄')
call s:UnicodeJumpsShortcuts('r', '◇') " 'r' for 'rhombus'
